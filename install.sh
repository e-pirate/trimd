#!/bin/bash

if [ "$UID" -ne "0" ]; then
    echo "error: You mast be root to run this script."
    exit 77
fi

SYSTYPE="${1}"

if [[ ${SYSTYPE} != 'initd' && ${SYSTYPE} != 'systemd' ]]; then
    echo "You mast specify system type as a script parameter:"
    echo "$0 <initd|systemd>"
    exit 64
fi

echo Installing trimd...

INSTALL='/usr/bin/install -v -g root -o root'

${INSTALL} -m 755 usr/sbin/trimd.sh /usr/sbin/

if [ ! -e /etc/conf.d/trimd ]; then
    ${INSTALL} -m 644 etc/conf.d/trimd /etc/conf.d/
fi

case ${SYSTYPE} in
    initd)
        ${INSTALL} -m 755 etc/init.d/trimd /etc/init.d/
        echo "To start trimd run: /etc/init.d/trimd start"
    ;;
    systemd)
        ${INSTALL} -m 755 usr/lib/systemd/system/trimd.service /usr/lib/systemd/system/trimd.service
        echo "To start trimd run: systemctl daemon-reload && systemctl start trimd"
    ;;
esac

echo "Find more information in README.md"
