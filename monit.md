apt-get install monit

vim /etc/inittab

# Add to end of /etc/inittab
mo:2345:respawn:/usr/bin/monit -Ic /etc/monit/monitrc
mon:2345:wait:/usr/bin/monit -Ic /etc/monit/monitrc start all
moff:06:wait:/usr/bin/monit -Ic /etc/monit/monitrc stop all

chkconfig monit off


# Modify monit to include specific files
vim /etc/monit/monitrc
include /etc/monit/conf.d/00_include

vim /etc/monit/conf.d/00_include
include exim4
include fail2ban
include system
# ...

