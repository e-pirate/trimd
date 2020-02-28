#!/bin/bash

if [ "$UID" -ne "0" ]; then
    echo "Error: You mast be root to run this script."
    exit 77
fi

SYSTYPE="${1}"

if [[ ${SYSTYPE} != 'initd' && ${SYSTYPE} != 'systemd' ]]; then
    echo "You mast specify system type as a script parameter:"
    echo "$0 <initd|systemd>"
    exit 64
fi

echo "Installing trimd.."

SRCDIR="$(dirname $0)"
INSTALL='/usr/bin/install -v -g root -o root'

${INSTALL} -m 755 ${SRCDIR}/usr/sbin/trimd.sh /usr/sbin/

if [ -d /etc/conf.d ]; then
    CONFIG='/etc/conf.d/trimd'
else if [ -d /etc/sysconfig ]; then
    CONFIG='/etc/sysconfig/trimd'
else
    CONFIG='/etc/trimd.conf'
fi
[ ! -e ${CONFIG} ] && ${INSTALL} -m 644 ${SRCDIR}/etc/trimd.conf ${CONFIG}

case ${SYSTYPE} in
    initd)
        ${INSTALL} -m 755 ${SRCDIR}/etc/init.d/trimd /etc/init.d/
        sed -i "s|_CFGPATH_|${CONFIG}|" /etc/init.d/trimd
        echo "To start trimd run: /etc/init.d/trimd start"
    ;;
    systemd)
        ${INSTALL} -m 644 ${SRCDIR}/usr/lib/systemd/system/trimd.service /usr/lib/systemd/system/trimd.service
        sed -i "s|_CFGPATH_|${CONFIG}|g" /usr/lib/systemd/system/trimd.service
        echo "To start trimd run: systemctl daemon-reload && systemctl start trimd"
    ;;
esac

echo "Find more information in README.md"
