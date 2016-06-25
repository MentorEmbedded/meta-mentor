u-boot Support for Xilinx ZC702EK
=================================

The recipe in this directory will build a u-boot image suitable for booting
Mentor Embedded Linux on a ZC702EK from an SD card.  Note that the High
Definition Media Interface (HDMI) is configured by programmable logic on the
board and requires a bitstream at initialization before it can be identified and
used by Linux.  The u-boot image created in this recipe *does not* contain a
suitable bitstream for initializing the HDMI interface.

The provided _mel-boot.bin_ includes such support and should be loaded directly on
your flash media card if you require the use of the HDMI interface.

Should you need to build your own _boot.bin_ with support for the HDMI
interface, you will need to refer to your Xilinx SDK documentation on the
appropriate procedure to follow.

Booting
-------

Booting from an SD card can be accomplished with the following procedure:

1. Configure SW16.1 thorugh SW16.5 as follows:

             +---------------------------------------------------+
             |  SW16.1    SW16.2    SW16.3    SW16.4    SW16.5   |
             |  +----+    +----+   +------+  +------+   +----+   |
             |  |    |    |    |   |//////|  |//////|   |    |   |
             | ++----++  ++----++  ++----++  ++----++  ++----++  |
             | |//////|  |//////|   |    |    |    |   |//////|  |
             | +------+  +------+   +----+    +----+   +------+  |
             +---------------------------------------------------+

   SW16.1 = 0
   SW16.2 = 0
   SW16.3 = 1
   SW16.4 = 1
   SW16.5 = 0

2. Format your SD card with (at least) two partitions.  The first should be
   _FAT-32_ / _VFAT_.  The second should be _ext2_ / _ext3_ / _ext4_.  An
   optional third partition could be used for _swap_ if desired.

3. Copy the following files from your MEL project build top directory to the
   root directory of the *first partition* of the SD card:

      tmp/deploy/images/zc702-zynq7/uImage
      tmp/deploy/images/zc702-zynq7/uImage-zynq-zc702-base-trd.dtb
      tmp/deploy/images/zc702-zynq7/uEnv.txt

   and one of:
      tmp/deploy/images/zc702-zynq7/u-boot.bin
      tmp/deploy/images/zc702-zynq7/mel-boot.bin

   named:
      boot.bin

4. Extract the Mentor Embedded Linux filesystem image to the *second partition*
   of your SD card with a command such as:

      sudo tar -C /mnt -zxf \
         tmp/deploy/images/zc702-zynq7/core-image-sato-zc702-zynq7.tar.gz

   assuming you have the second partition of your SD card mounted on */mnt*.

