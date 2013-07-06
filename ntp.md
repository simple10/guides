```bash
# Install ntp daemon
apt-get install ntp

# Enable SELinux policy
cd /usr/share/selinux/default/
semodule -i ntp.pp

# Disable NTP in init.d and start with monit instead
chkconfig ntp off
vim /etc/init.d/conf.d/ntp
# See ntp monit conf below
```


## Monit Config for NTP

```bash
# /etc/monit/conf.d/ntp

check process ntp with pidfile /var/run/ntpd.pid
  group time
  start program = "/etc/init.d/ntp start"
  stop  program = "/etc/init.d/ntp stop"
  if 5 restarts within 5 cycles then timeout
  depends on ntp.bin
  depends on ntp.rc

check file ntp.bin with path /usr/sbin/ntpd
  group time
  if failed checksum then unmonitor
  if failed permission 755 then unmonitor
  if failed uid root then unmonitor
  if failed gid root then unmonitor

check file ntp.rc with path /etc/init.d/ntp
  group time
  if failed checksum then unmonitor
  if failed permission 755 then unmonitor
  if failed uid root then unmonitor
  if failed gid root then unmonitor

```