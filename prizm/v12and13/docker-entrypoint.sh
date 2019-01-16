#!/bin/sh
license_value=`cat /run/secrets/prizm_license`

/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" $license_value \
    && /usr/share/prizm/scripts/pccis.sh start \
    && tail -f /dev/null