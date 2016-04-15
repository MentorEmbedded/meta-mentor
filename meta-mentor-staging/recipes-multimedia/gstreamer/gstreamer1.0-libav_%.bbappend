# ffmpeg/libav disables PIC on some platforms (e.g. x86-32)
INSANE_SKIP_${PN} = "textrel"
