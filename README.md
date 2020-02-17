trimd
===========

Lightweight but versatile and powerful daemon the trims SSD on a regular basis.


MOTIVATION
-----------------------------------------

This little daemon utilizes fstrim utility and will trim all partitions/file systems that support TRIM operation. It also provides configuration of initial delay after daemon start, time between periodic trims, maximum LA at which trim is allowed and aware of possible system sleep/hibernation.

Inspired by: https://github.com/dobek/fstrimDaemon


INSTALLATION
-----------------------------------------

### Run as root:
```
./install.sh
```

### To start daemon if you are using init.d:
```
/etc/init.d/trimd start
```

### To start daemon if you are using systemd:
```
systemctl start trimd

### To start daemon automatically at each boot if you are using systemd:
```
systemctl enable trimd
```

### To stop daemon if you are using init.d:
```
/etc/init.d/trimd stop
```

### To uninstall run as root:
```
./uninstall.sh
```
If you are using systemd, uninstall.sh will stop and disable the daemon

Files which are not removed during uninstallation:
- _/etc/conf.d/fstrimDaemon_
- _/var/log/fstrimDaemon.log_


CONFIGURATION
-----------------------------------------


Default config file: _/etc/conf.d/fstrimDaemon_

```bash
# Time to wait after daemon start to perform first fstrim
# e.g. "30m" - 30 minutes. See man sleep.
SLEEP_AT_START="2h"

# Time to sleep between next repetition of fstrim
# e.g. "5d" - 5 days. See man sleep.
SLEEP_BEFORE_REPEAT="3h"

# Maximum CPU Load when fstrim is allowed.
# If current CPU Load is above daemon sleeps for 5 min.
# 1.0 means all cores are busy.
MAX_CPU_LOAD="0.2"

# integer [-20 .. 19 ] default 0
# change the priority of the server -20 (high) to 19 (low)
# see nice(1) for description
NICE="19"

# See start-stop-daemon(8) for possible settings
# Modifies the IO scheduling priority of the daemon.  Class
# can be 0 for none, 1 for real time, 2 for best effort and 3
# for idle.  Data can be from 0 to 7 inclusive.
IONICE="3"

# Here Daemon's process id will be stored
PID="/var/run/fstrimDaemon.pid"

# Here Daemon logs
LOG="/var/log/fstrimeDaemon.log"

# The main daemon script i.e. fstrim-sleep loop
DAEMON="/usr/sbin/fstrimDaemon.sh"
```

LOG
-----------------------------------------

See _/var/log/fstrimDaemon.log_


PROJECT HOME
-----------------------------------------

https://github.com/dobek/fstrimDaemon
