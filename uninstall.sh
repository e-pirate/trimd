#!/bin/bash

if [ "$UID" -ne "0" ]; then
    echo "Error: You mast be root to run this script."
    exit 77
fi

if [ ! -z "$(pgrep 'trimd.sh')" ]; then
    echo "Error: You mast stop trimd service before removing it"
    exit 1
fi

echo "Uninstalling trimd.."

rm -fv /usr/sbin/trimd.sh

[ -e /etc/init.d/trimd ] && rm -fv /etc/init.d/trimd
[ -e /usr/lib/systemd/system/trimd.service ] && rm -fv /usr/lib/systemd/system/trimd.service

echo You can manually remove:
echo - /etc/conf.d/trimd or /etc/trimd.conf
echo - /var/log/trimd.log if logging to file was used
echo
echo Find more information in README.md
