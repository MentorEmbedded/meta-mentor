PR = "r1"
DEPENDS := "${@oe_filter_out('virtual/libgl', '${DEPENDS}', d)}"
DEPENDS := "${@oe_filter_out('libglu', '${DEPENDS}', d)}"

EXTRA_OECONF += "--disable-video-opengl"
