FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

COPY pdutil.sh /usr/local/

# added for v11.2 (remove all of these for v12 or later):
	# imagemagick
	# xvfb
	# x11-xkb-utils
	# xfonts-base
	# xfonts-scalable
	# xfonts-unifont
	# xserver-xorg-core
	# xfonts-100dpi xfonts-75dpi xfonts-cyrillic
	# libxi6
# added for v12.4:
	# libgif4 \ 
	# libopenjpeg2 
RUN apt-get update \
	&& sed -i -e 's/\r$//' /usr/local/pdutil.sh \
	&& echo exit 0 > /usr/sbin/policy-rc.d \
	&& apt-get install locales -y \
	&& locale-gen en_US.UTF-8 \
	&& apt-get install dialog apt-utils -y \
	&& apt-get install -y fontconfig \
	&& apt-get install -y libcups2 \
	&& apt-get install -y libdbus-glib-1-2 \
	&& apt-get install -y libexif12 \
	&& apt-get install -y libjpeg62 \
	&& apt-get install -y libxinerama1 \
	&& apt-get install -y libxrender1 \
	&& apt-get install -y libxtst6 \
	&& apt-get install -y libxslt1.1 \
	&& apt-get install -y libglu1-mesa \
	&& apt-get install -y lsof \
	&& apt-get install -y libcairo2 \
	&& apt-get install -y libgif4 \ 
	&& apt-get install -y libopenjpeg2 \
	&& apt-get install -y imagemagick \
	&& apt-get install -y xvfb \
	&& apt-get install -y x11-xkb-utils \
	&& apt-get install -y xfonts-base \
	&& apt-get install -y xfonts-scalable \
	&& apt-get install -y xfonts-unifont \
	&& apt-get install -y xserver-xorg-core \
	&& apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-cyrillic \
	&& apt-get install -y libxi6 \
	&& /usr/local/pdutil.sh install --headless --version=11.2
	# to gen an image for v12 or v13, remove the --headless switch & 
	# update the --version or remove it to get latest

ENV DEBIAN_FRONTEND teletype

# v12 and v13 entrypoint:
# ENTRYPOINT /usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" [license key]  \
# 		&& /usr/share/prizm/scripts/pccis.sh start
# v11 entrypoint:
ENTRYPOINT Xvfb :20 &> /dev/null & export DISPLAY=:20 \
		&& usr/share/prizm/java/jre6-linux-x86-64/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" [license key]  \
		&& /usr/share/prizm/scripts/pccis.sh start \
		&& tail -f /dev/null