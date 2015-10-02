#This file contains the WIC bits that are common to all MEL BSPs

# WIC image type support
IMAGE_FSTYPES_append = " wic.bz2"

# dosfstools is needed to create the boot partition, mtools to copy to it
IMAGE_DEPENDS_wic_append = " dosfstools-native mtools-native"
