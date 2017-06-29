# The upstream buildsystem uses 'docdir' as the path where it puts AUTHORS,
# README, etc, but we don't want those in the root of our docdir.
docdir_append_task-install = "/${BPN}"
