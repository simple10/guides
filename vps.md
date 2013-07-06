Assumes Debian or Ubuntu.

Login as root

```bash
# INTERACTIVE

# Make sure apt sources.list is setup
# See http://debgen.simplylinux.ch/
vim /etc/apt/sources.list
# Common sources...
deb http://ftp.us.debian.org/debian wheezy main
deb http://ftp.debian.org/debian/ wheezy-updates main
deb http://security.debian.org/ wheezy/updates main
```

```bash
# COPY AND PASTE
apt-get update
apt-get upgrade
apt-get install fail2ban
apt-get install ufw
apt-get install chkconfig
apt-get install htop
apt-get install ntp
```

```bash
# INTERACTIVE

# Modify /etc/hosts to use hostname with public IP address and not 127.0.0.1
# This allows system emails and other services that use gethostbyname() to
# use the hostname instead of localhost. Alternatively, the hostname can be
# moved in front of localhost: 127.0.0.1 somehostname localhost
vim /etc/hosts
127.0.0.1	localhost
<public ip address>	<hostname>
# e.g. 198.192.0.100   droplet


# Copy this repo etc/.bashrc file and paste it into /etc/skel/.bashrc
vim /etc/skel/.bashrc

# Create admin user "joe"
adduser joe
# Add joe to sudo group
usermod -a -G sudo joe

# Authorize joe to login using ssh keys
# From a machine that already has joe's pub key...
ssh-copy-id -i ~/.ssh/id_rsa.pub joe@<SERVER IP>

# Verify sudo group is setup properly
visudo
# Should look like...
# %sudo   ALL=(ALL:ALL) ALL
# See security.md guide for more details

# Test logging in without a password
ssh joe@<SERVER IP> -p 1234
# Test sudo
sudo su -

# Disable password and root ssh and optionally change port
vim /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
# Port 1234
service ssh restart

# Update ssh port in /etc/services if changed in /etc/ssh/sshd_config
vim /etc/services
# ssh             1234/tcp
# ssh             1234/udp

# Cleanup
rm -rf /root/.ssh

# Setup firewall
ufw default deny incoming
ufw default allow outgoing
# Allow ssh on whatever port you set in sshd_config
ufw allow ssh
ufw enable
ufw status verbose
# See https://help.ubuntu.com/community/UFW

# Configure fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
vim /etc/fail2ban/jail.local
# Modify destemail and enable services as needed
# Restart fail2ban
service fail2ban restart

# Setup unattended security upgrades
# See security.md guide

# Remove unneeded packages and services
chkconfig -l
ps aux

apt-get purge consolekit
```






# Database or IO Intensive Servers

```bash
# Disable mlocate
chmod -x /etc/cron.daily/mlocate
# Or
apt-get purge mlocate
# Or add 'exit 0' to the second line of the script
```


