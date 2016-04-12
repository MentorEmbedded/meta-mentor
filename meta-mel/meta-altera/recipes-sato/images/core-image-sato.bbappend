# Xvfb is needed for headless remote display setup for cyclone5
IMAGE_INSTALL_append_cyclone5 = " xserver-xorg-xvfb \
				  mesa-megadriver \
				  xserver-xorg-extension-glx \
				  webkitgtk \
				"

# Install OpenJDK 7 JRE if ENABLE_JAVA is set to "1"
python () {
    if d.getVar("ENABLE_JAVA", True) == "1":
        d.setVar('IMAGE_INSTALL_append', ' openjdk-7-jre')
}
