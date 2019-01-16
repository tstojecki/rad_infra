#!/bin/sh
license_value=`cat /run/secrets/prizm_license`

Xvfb :20 &> /dev/null & export DISPLAY=:20 \
    && /usr/share/prizm/java/jre6-linux-x86-64/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" $license_value \
    && /usr/share/prizm/scripts/pccis.sh start \
    && tail -f /dev/null