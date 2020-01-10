#!/bin/sh

MY_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
. ${MY_DIR}/../sh-test-lib

DEMO_HELLO_WORLD="${my_dir}/hello-world"
DEMO_STACK_SMASH="${my_dir}/stack-smash"

usage() {
    echo "$0 [-a <hello-world-demo-abs-path> -s <stack-smash-demo-abs-path>]" 1>&2
    exit 1
}

while getopts "a:s:h" o; do
    case "$o" in
        a) DEMO_HELLO_WORLD="${OPTARG}" ;;
        s) DEMO_STACK_SMASH="${OPTARG}" ;;
        h|*) usage ;;
    esac
done

set_permissive_mode() {
    setenforce 0
    getenforce | grep -q "Permissive"
    exit_on_fail "SELinux permissive mode enabled" "setenforce not working properly!"
}

set_enforcing_mode() {
    setenforce 1
    getenforce | grep -q "Enforcing"
    exit_on_fail "SELinux enforcing mode enabled" "setenforce not working properly!"
}

create_demo_te(){
    cat << EOF > demo.te
module demo 1.0.0;

require {
    type unconfined_t;
    role unconfined_r;
    class process transition;
}

type demo_t;
type demo_exec_t;

role unconfined_r types demo_t;
type_transition unconfined_t demo_exec_t : process demo_t;
EOF
}

load_package_policy() {( set -e
    [ "$#" -ne 1 ] && error_msg "Usage: create_patch demo-name"
    if [ -f $1.te ]; then
        checkmodule -M -m $1.te -o $1.mod &> /dev/null
        semodule_package -m $1.mod -o $1.pp
        semodule -i $1.pp
        return 0
    else
        warn_msg "$1.te doesn't exist"
        return 1
    fi
)}

# Run hello-world demo to check audit support
hello_world_demo() {
    info_msg "Running hello_world_demo..."
    set_permissive_mode

    info_msg "Removing any previous package policy corresponding to custom type: demo"
    prev_demo_list=$(semodule -l | grep "demo")
    if [ ! -z "$prev_demo_list" ]; then
        semodule -r $prev_demo_list &> /dev/null
    fi

    if [ -f "${DEMO_HELLO_WORLD}" ]; then
	cp ${DEMO_HELLO_WORLD} helloWorld
	create_demo_te
        check_return "Demo type enforcement file created" "Couldn't create demo type enforcement file!" || return 1;

        load_package_policy "demo"
        check_return "Loaded initial package policy corresponding to demo.te" "Couldn't load package policy corresponding to demo.te!" || return 1;

	chcon -t demo_exec_t helloWorld
	ls -lZ helloWorld | grep -q demo_exec_t
        check_return "Changed the helloWorld binary context to newly created custom type: demo" "helloWorld binary context changing failed!" || return 1;

        ./helloWorld
        set_enforcing_mode
        ./helloWorld
	if [ $? -eq 0 ]; then
	    warn_msg "Demo shouldn't execute with incomplete permissions!"
            return 1;
	fi

        i=1
        while grep -q "demo" /var/log/audit/audit.log; do
            info_msg "Creating package policy patch-$i using audit2allow"
            grep demo /var/log/audit/audit.log | audit2allow -M "demo-patch-$i"

            #Remove previously captured audit logs
            grep demo -v /var/log/audit/audit.log > tmp
            cat tmp > /var/log/audit/audit.log

            semodule -i "demo-patch-$i.pp"
            ./helloWorld
            ((i++))
            if [ $i -gt 5 ]; then
                warn_msg "audit2allow couldn't allow all permissions in 5 patches!"
                return 1;
            fi
        done
    else
        warn_msg "${DEMO_HELLO_WORLD} doesn't exist"
        return 1;
    fi
}

# Run stack-smash demo to check memory protection
stack_smash_demo(){
    if [ -f $DEMO_STACK_SMASH ]; then
        set_enforcing_mode
        $DEMO_STACK_SMASH &> stack_smash.log
        grep "mprotect: Permission denied" stack_smash.log
	check_return "Stack smash demo executed successfully" "Error in stack smash demo!"
    else
        warn_msg "$DEMO_STACK_SMASH doesn't exist"
	report_fail "Error in stack smash demo!"
    fi
}

info_msg "About to run SELinux example..."

# Check kernel config
if [ -f /proc/config.gz ]; then
    CONFIG_SECURITY_SELINUX=$(zcat /proc/config.gz | grep "CONFIG_SECURITY_SELINUX=")
else
    error_msg "Kernel config file: /proc/config.gz not found!"
fi

[ "${CONFIG_SECURITY_SELINUX}" = "CONFIG_SECURITY_SELINUX=y" ]
exit_on_fail "CONFIG_SECURITY_SELINUX is enabled" "Kernel config CONFIG_SECURITY_SELINUX not enabled!"

seinfo
check_return "seinfo complete" "seinfo returned error!"

semanage boolean -l
check_return "semange complete" "semange returned error!"

semodule --list=full
check_return "semodule complete" "semodule returned error!"

sestatus -v
check_return "sestatus complete" "sestatus returned error!"

hello_world_demo
check_return "helloWorld binary with a custom type executed successfully" "Couldn't execute helloWorld binary with custom type!"

stack_smash_demo

