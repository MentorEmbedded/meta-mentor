Mentor Embedded Linux Flex OS Distribution Layer for Yocto/OE
=====================================================

This layer holds the Mentor Embedded Linux Flex OS distro configuration and
associated policy.

This layer depends on:

URI: git://git.openembedded.org/openembedded-core
Branch: master

URI: git://git.yoctoproject.org/meta-yocto
Revision: master

We recommend including meta-mel-support and meta-mentor-staging as well, but
these shouldn't be required.


Contributing
------------

Browse url: http://git.yoctoproject.org/cgit/cgit.cgi/meta-mentor
Clone url: git://git.yoctoproject.org/meta-mentor.git

To contribute to this layer you should submit the patches for review to the
mailing list.

Mailing list: meta-mentor@yoctoproject.org

When sending single patches, please use something like
'git send-email -1 --subject-prefix 'PATCH][meta-mel' --to meta-mentor@yoctoproject.org'

When sending a series, please use oe-core/scripts/create-pull-request.
