trimd
===========

Lightweight but versatile and powerful daemon that trims SSD on a regular basis.


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
```

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
- /etc/conf.d/trimd


CONFIGURATION
-----------------------------------------


Default config file: /etc/conf.d/trimd

```bash
# Time after daemon start before first trim will be performed
# Default is 2h. For other possible values check sleep manual
SLEEP_AT_START="2h"

# Time between periodic trim operations
# Default is 4h, same as above
SLEEP_BEFORE_REPEAT="4h"

# Maximum average LA of a single core when trim will be performed
# If LA is above this value, daemon will wait for 1 min until LA
# drops down. LA of 1.0 means all cores are busy.
MAX_LA="0.5"

# Divide sleep into sleep chunks (in seconds) in order to
# prevent including system suspend/sleep time into sleep time and
# performing trim just after system resume.
SLEEP_CHUNK=1800

# Daemon preority integer in interval -20 (high) to 19 (low),
# Default 0, see man nice for description
NICE="0"

# IO scheduling priority of the daemon.  Class  can be 0 for none,
# 1 for real time, 2 for best effort and 3 for idle. Can be from 
# 0 to 7 inclusive. See start-stop-daemon(8) for possible settings
IONICE="0"

# Daemon PID file
PID="/var/run/trimd.pid"

# Daemon log. Leave empty for system default.
#LOG="/var/log/trimd.log"

# Main daemon script file
DAEMON="/usr/sbin/trimd.sh"
```

LOG
-----------------------------------------

See system log (i.e. /var/log/messages) or file defined by LOG variable in config.


PROJECT HOME
-----------------------------------------

https://github.com/e-pirate/trimd
