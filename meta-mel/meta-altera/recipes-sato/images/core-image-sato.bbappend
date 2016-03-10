# Xvfb is needed for headless remote display setup for cyclone5
IMAGE_INSTALL_append_cyclone5 = " xserver-xorg-xvfb \
				  mesa-megadriver \
				  xserver-xorg-extension-glx \
				"
