FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

COPY pdutil.sh /usr/local/

# added libgif4, libopenjpeg2 for Prizm v12.4 install
# added imagemagick for Prizm v11.2 install
# removed && apt-get install -y xvfb \ not needed anymore
RUN apt-get update \
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

ENV DEBIAN_FRONTEND teletype

# Prizm v13 license key: 2.0.EHK8bLrzIHX5bhKU93bHW39LIhI4IUR4b4XzWHGstAWsizb5E3EyGaGfn5WHELRsR5cabLnzIHWLIh9UiUiHK3XfXhWpXUb4WpXzIzrsIAb8tzK1n3ryiyihGfQzGAQUW1OyQLRHXHifEhO39sO5IUrfnhQyEUGatyO5X1EsRAE3W5nHK3tyI4WhX1QHKhbst1GaIfOHX5OhIh9UcUGHn3KLnhcpiUt4i4rHOzKsXAWsIzG1r3EycatLI1WTiLXsi59y9LczRHQfrAcUEUXHW39LbhcptUI4rpiHKHE3ifb8tHn1c3KaQyWLb1nHKfW8Q19aXhX5iAQfKAO4XUtHK39LRhKpQUO4rpiHKHXUifOUWHn1RUWatyXAcHO5r5GyWfQ8Q5bA9hI1Ih93OsQ5O8rfWAE4E3KaEaG1iAnyIHKaWHE5K39sc8QfX1chGLtsK5Oyb1cAQhW1cAnpIpXh93tLIhOpbUK4t3RzXzKsXzIsiz91EUiaXQ9Hs \
# Prizm v12 license key: 2.0.E6Aorkh81b4SmxZkRx7dAkuJGN4SukB25216GNr87opNONpJ1T1wA2hwhHAxmUBM18Zb4TuJhH52Gb18pUZS7SBTGbD8Bw7UZUGUASRH5U12OT1kGS4oD8m8Od7SO6uk4HuTBH42R2h2pM4oGNpdB2BM5wDdDURJ4SDSBb16RwhN427MGkOd7HZM4oZNr6OJOJuJ7xATuT46Ox1J4JA8r2OMZSrdhk1MRJmS58hbZxu81MrdR25wh2OoZUuJ7J4kYoD6romNDd4848RUmS7b7JATmHhx1NpTZxZbZdZwh8pomo4xmJZHrUr65kGoBoANON1U78ZNZdBHZTuNZM7N1J5bhbBxrTANDURdm8BbBTrJ7d5JB2GHRkuMpx5MhT7dDTRxGo1khUmxOwAbGU1NrHrHmb5dhk467N4HDNh6rkmH7x4NOJ18RwhUrTmkh642185d1xDdZbmMAMAS1kOTuwuMZURbAHG2Zx1oOTAxr2ukOopkD87brdAwAoOS4TBW4A8 \
# ENTRYPOINT /usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" 2.0.ETfo0c0X18VYf4x4tYfcxrdyfXfoxrjn2ldrjWfsiTjmgWxYRnPmS4dXR8PcxcEcPYicxrST2rjotr0nEUtXfWisjTRWPmSY1nwmic1rgciYf4Ps2l142rPT2rdoiXVowltmgr180yPWSrPYfyRmVsxmi81ct8d4Rl0sir2oEmVo0rjywMdXSmj8PytrRX0MwnEmPcfXP8dcPcw42YEcfXwTVX0oxrfniUfrjW0sSyPWgWfYwnRmYc1Xw82ci424SYtctrPTVXgowrfndU1XimR8gnPXPmSMtnwm04tr2s2ctcxciMj4iX2o1WEmgXinw80rVWfsdTwWEWtYRnVWg4xrE4ws0sEc1Yt4wXEySWwTVWdWxstydnil2X0oxo0MwoxrE81W2sj424dcil2sEWRXdTjmtTRofliyjWjUEXwWEW14fnPmPcVXPl2MtM241YgMtrxTiX0WSrVmfUirioEUEXRoiW14SntW24RREPy \
# 		&& /usr/share/prizm/scripts/pccis.sh start
ENTRYPOINT Xvfb :20 &> /dev/null & export DISPLAY=:20 \
		&& usr/share/prizm/java/jre6-linux-x86-64/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" 2.0.ETfo0c0X18VYf4x4tYfcxrdyfXfoxrjn2ldrjWfsiTjmgWxYRnPmS4dXR8PcxcEcPYicxrST2rjotr0nEUtXfWisjTRWPmSY1nwmic1rgciYf4Ps2l142rPT2rdoiXVowltmgr180yPWSrPYfyRmVsxmi81ct8d4Rl0sir2oEmVo0rjywMdXSmj8PytrRX0MwnEmPcfXP8dcPcw42YEcfXwTVX0oxrfniUfrjW0sSyPWgWfYwnRmYc1Xw82ci424SYtctrPTVXgowrfndU1XimR8gnPXPmSMtnwm04tr2s2ctcxciMj4iX2o1WEmgXinw80rVWfsdTwWEWtYRnVWg4xrE4ws0sEc1Yt4wXEySWwTVWdWxstydnil2X0oxo0MwoxrE81W2sj424dcil2sEWRXdTjmtTRofliyjWjUEXwWEW14fnPmPcVXPl2MtM241YgMtrxTiX0WSrVmfUirioEUEXRoiW14SntW24RREPy \
		&& /usr/share/prizm/scripts/pccis.sh start \
		&& tail -f /dev/null
