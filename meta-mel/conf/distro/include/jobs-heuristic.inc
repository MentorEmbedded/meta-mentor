# Set bitbake threads and make jobs based upon available memory per CPU core.
# Based on https://elinux.org/images/d/d4/Goulart.pdf, a talk done by Mario Domenech
# Goulart and Mikko Rapeli from BMW CAR IT GMBH.
#
# MEM_PER_CPU_MINIMUM,THREADS,JOBS,ACTION
JOBS_HEURISTIC_THRESHOLDS ?= "\
    7.9,cpus,cpus*1.5, \
    3.9,cpus,cpus, \
    1.9,cpus//2,cpus//2,WARN \
    0,,,FATAL \
"

# This function postpones warnings to reduce duplication, and postpones failures
# to avoid breaking bitbake -e.
python jobs_heuristic() {
    """Set bitbake threads and make jobs based upon available memory per CPU core."""
    cpus = oe.utils.cpu_count()
    try:
        mem_total = mem_total_gigs()
    except Exception:
        d.setVar('JOBS_HEURISTIC_WARNING',
                 'Failed to determine system total memory for threads and jobs heuristic.')
        return
    mem_per_cpu = mem_total / cpus

    if cpus == 1:
        threads, jobs = 1, 1
    else:
        for entry in d.getVar('JOBS_HEURISTIC_THRESHOLDS').split():
            split = entry.split(',')
            try:
                required_mem_per_cpu, threads, jobs, action = split
            except ValueError:
                d.setVar('JOBS_HEURISTIC_ERROR',
                         'Invalid entry in JOBS_HEURISTIC_THRESHOLDS: %s. Expected: MEM_PER_CPU_MINIMUM,THREADS,JOBS,ACTION' % entry)
                return

            if mem_per_cpu >= float(required_mem_per_cpu):
                if action:
                    if action == 'FATAL':
                        d.setVar('JOBS_HEURISTIC_ERROR',
                                 'Not enough memory per CPU core (~%s Gb) in this system, exiting.' % int(mem_per_cpu))
                        return
                    elif action == 'WARN':
                        d.setVar('JOBS_HEURISTIC_WARNING',
                                 'Low memory per CPU core (~%s Gb) in this system, parallelization has been scaled down.' % int(mem_per_cpu))

                try:
                    threads = int(eval(threads)) if threads else 1
                except Exception as exc:
                    d.setVar('JOBS_HEURISTIC_ERROR',
                             'Failed to evaluate threads (%s) in JOBS_HEURISTIC_THRESHOLDS entry %s: %s' % (
                                threads, entry, exc))
                    return

                try:
                    jobs = int(eval(jobs)) if jobs else 1
                except Exception as exc:
                    d.setVar('JOBS_HEURISTIC_ERROR',
                             'Failed to evaluate jobs (%s) in JOBS_HEURISTIC_THRESHOLDS entry %s: %s' % (
                                jobs, entry, exc))
                    return
                break
        else:
            return

    bb.debug(1, 'Memory per CPU core is %s, adjusting BB_NUMBER_THREADS to %s and PARALLEL_MAKE to %s' %
                  (mem_per_cpu, threads, jobs))
    d.setVar('BB_NUMBER_THREADS_HEURISTIC', str(max(threads, 1)))
    d.setVar('PARALLEL_MAKE_HEURISTIC', '-j %s' % max(jobs, 1))
}
jobs_heuristic[eventmask] = "bb.event.ConfigParsed"
addhandler jobs_heuristic

def mem_total_gigs():
    if os.path.exists('/proc/meminfo'):
        with open('/proc/meminfo', 'rb') as f:
            splitlines = [l.split()[:2] for l in f.readlines()]
            data = dict((k.strip()[:-1].decode('utf-8'), int(v.strip())) for k, v in splitlines)
            total = data.get('MemTotal')
            if total:
                return total / 1024 / 1024

python jobs_heuristic_sanity() {
    """Inform the user about issues with their system resources."""
    fatal = d.getVar('JOBS_HEURISTIC_ERROR')
    if fatal:
        bb.fatal(fatal)

    warn = d.getVar('JOBS_HEURISTIC_WARNING')
    if warn:
        bb.warn(warn)
}
jobs_heuristic_sanity[eventmask] = "bb.event.SanityCheck bb.build.BuildStarted"
addhandler jobs_heuristic_sanity
