PR = "r1"
DEPENDS := "${@oe_filter_out('virtual/libgl', '${DEPENDS}', d)}"

EXTRA_OECONF += "--disable-video-opengl"


