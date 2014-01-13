Mentor Graphics Staging Layer for Yocto/OE
==========================================

This layer holds the bits we need for Mentor Embedded Linux, but which we
intend to get merged upstream. This is our staging area. Nothing should be in
this layer permanently, other than layer.conf and associated bits.

This layer depends on:

URI: git://git.openembedded.org/openembedded-core
Branch: master


Contributing
------------

Browse url: http://git.yoctoproject.org/cgit/cgit.cgi/meta-mentor
Clone url: git://git.yoctoproject.org/meta-mentor.git

To contribute to this layer you should submit the patches for review to the
mailing list.

Mailing list: meta-mentor@yoctoproject.org

When sending single patches, please use something like
'git send-email -1 --subject-prefix 'PATCH][meta-mentor-staging' --to meta-mentor@yoctoproject.org'

When sending a series, please use poky/meta/scripts/create-pull-request (aka
oe-core/scripts/create-pull-request).
