# ---------------------------------------------------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
# ---------------------------------------------------------------------------------------------------------------------

import os
import logging
import tempfile
import urllib.parse

from oeqa.utils.commands import runCmd, bitbake, get_bb_var, create_temp_layer
from oeqa.utils.decorators import testcase
from oeqa.selftest.cases import recipetool


templayerdir = None


def setUpModule():
    global templayerdir
    templayerdir = tempfile.mkdtemp(prefix='recipetool-mel-qa')
    create_temp_layer(templayerdir, 'selftest-recipetool-mel')
    runCmd('bitbake-layers add-layer %s' % templayerdir)


def tearDownModule():
    runCmd('bitbake-layers remove-layer %s' % templayerdir, ignore_status=True)
    runCmd('rm -rf %s' % templayerdir)


class RecipetoolMelTests(recipetool.RecipetoolAppendsrcBase):
    def setUpLocal(self):
        super(RecipetoolMelTests, self).setUpLocal()
        self.templayerdir = templayerdir

    def _test_kernel_cmd(self, cmd, target, expected_file_info):
        testrecipe = get_bb_var('PN', target)
        machine = get_bb_var('MACHINE')
        expectedfiles = [os.path.join(machine, i) for i in expected_file_info.keys()]

        bbappendfile, _ = self._try_recipetool_appendcmd(cmd, testrecipe, expectedfiles)

        src_uri = get_bb_var('SRC_URI', testrecipe).split()
        for f, destdir in expected_file_info.items():
            if destdir:
                self.assertIn('file://%s;subdir=%s' % (f, destdir), src_uri)
            else:
                self.assertIn('file://%s' % f, src_uri)

        filesdir = os.path.join(os.path.dirname(bbappendfile), testrecipe)
        filesextrapaths = get_bb_var('FILESEXTRAPATHS', testrecipe).split(':')
        self.assertIn(filesdir, filesextrapaths)


    # FIXME: the test files should end in .dts
    def test_kernel_add_dts(self):
        testrecipe = 'virtual/kernel'
        srcdir = get_bb_var('S', testrecipe)
        workdir = get_bb_var('WORKDIR', testrecipe)
        if srcdir == get_bb_var('STAGING_KERNEL_DIR', testrecipe):
            # If S is directly set to STAGING_KERNEL_DIR, then we most likely
            # have a custom checkout or unpack process like linux-yocto, so we
            # don't know precisely where to place the files relative to
            # WORKDIR. We default to 'git' in this case.
            subdir = 'git'
        else:
            subdir = os.path.relpath(srcdir, workdir)
        destdir = 'arch/\\${ARCH}/boot/dts'
        if subdir != '.':
            destdir = os.path.join(subdir, destdir)

        expected_file_info = {
            os.path.basename(self.testfile): destdir,
            'testfile2': destdir,
        }

        testfile2 = os.path.join(self.tempdir, 'testfile2')
        with open(testfile2, 'w') as f:
            f.write('Test File 2')

        cmd = 'recipetool kernel_add_dts %s %s %s' % (self.templayerdir, self.testfile, testfile2)
        self._test_kernel_cmd(cmd, testrecipe, expected_file_info)

        devtree = get_bb_var('KERNEL_DEVICETREE', testrecipe)
        if not devtree:
            self.fail('KERNEL_DEVICETREE not defined')
        devtree = devtree.split()

        for f in expected_file_info:
            self.assertIn(f.replace('dts', 'dtb'), devtree)

    def test_kernel_add_fragments(self):
        fragments = []
        for i in range(1, 5):
            fn = os.path.join(self.tempdir, 'fragment%d.cfg' % i)
            fragments.append(fn)
            open(fn, 'w')

        cmd = 'recipetool kernel_add_fragments %s %s' % (self.templayerdir, ' '.join(fragments))
        self._test_kernel_cmd(cmd, 'virtual/kernel', dict((os.path.basename(i), None) for i in fragments))

    def test_kernel_set_configs(self):
        # TODO: check the generated fragment content
        cmd = 'recipetool kernel_set_configs %s CONFIG_ONE=y CONFIG_TWO=n' % self.templayerdir
        self._test_kernel_cmd(cmd, 'virtual/kernel', {'recipetool0.cfg': None})

    def test_kernel_set_defconfig(self):
        cmd = 'recipetool kernel_set_defconfig -r linux-dummy %s %s' % (self.templayerdir, self.testfile)
        self._test_kernel_cmd(cmd, 'linux-dummy', {'defconfig': None})
