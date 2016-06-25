# qtmultimedia needs gstreamer, not a random collection of plugins with
# questionable quality
DEPENDS_remove_pn-qtmultimedia = "gstreamer1.0-plugins-bad"
