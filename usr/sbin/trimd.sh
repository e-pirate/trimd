#!/bin/bash

FSTRIM="/sbin/fstrim"
VERSION="0.3"

source /etc/conf.d/trimd

cleanup()
{
        echo "Stopping trimd v$VERSION"
        for JOB in $(jobs -p); do
            [ $(< /proc/$JOB/comm) != 'fstrim' ] && kill $JOB                                           # avoid killing fstrim in progress
        done
        exit 0
}
trap "cleanup" SIGTERM                                                                                  # SIGINT will kill all child processes itself

function fractional_sleep()
{
    case "$1" in
        *s) DELAY="${1%?}";;
        *m) let "DELAY=${1%?} * 60";;
        *h) let "DELAY=${1%?} * 3600";;
        *d) let "DELAY=${1%?} * 86400";;
        *) DELAY="$1";;
    esac 
    let "ROUNDS=${DELAY} / ${SLEEP_CHUNK}"
    let "REMAINDER=${DELAY} % ${SLEEP_CHUNK}"
    for COUNTER in $(seq 1 ${ROUNDS}); do
        sleep ${SLEEP_CHUNK} & wait                                                                     # wait is needed for trap been executed immediately after receiving the signal
    done
    sleep ${REMAINDER} & wait
}

echo "Strarting trimd v$VERSION"

fractional_sleep ${SLEEP_AT_START}                                                                      # Initial delay after first start

CORES=$(getconf _NPROCESSORS_ONLN)
while true; do
    while [ $(bc -l <<< "($(awk '{print $1}' /proc/loadavg) / ${CORES}) < ${MAX_LA}") == 0 ]; do        # Wait for CPU LA goes below predefined level
        fractional_sleep 60s
    done

    TRIMLIST=''                                                                                         # Get catual trimable mountpoints
    while IFS='\n' read -r LINE; do
        MOUNTPOINT="${LINE%%' '*}"                                                                      # copy from the beginning of the string to the first space
        LINE=${LINE#*' '}                                                                               # remove part from the beginning of the string till the first space
        if [[ -z ${MOUNTPOINT} || ! ${LINE%%' '*} =~ ^(btrfs|ext3|ext4|jfs|xfs|f2fs|vfat|ntfs)$ ]]; then continue; fi
        LINE=${LINE#*' '}
        if [[ ! ${LINE%%' '*} =~ ^(disk|part)$ || ${LINE#*' '} == '0B' ]]; then continue; fi
        TRIMLIST+="${MOUNTPOINT} "
    done < <(lsblk -rno MOUNTPOINT,FSTYPE,TYPE,DISC-GRAN)

    if [[ ! -z ${TRIMLIST} ]]; then                                                                     # Trim all suitable mountpoints
        for MOUNTPOINT in ${TRIMLIST[@]}; do
            RESULT=$(${FSTRIM} -v ${MOUNTPOINT} 2>&1)
            echo "Trimming ${RESULT}"
        done
    else
        echo "No trimable mountpoints detected, skipping run"
    fi

    fractional_sleep ${SLEEP_BEFORE_REPEAT}                                                             # Wait for the next iteration
done

