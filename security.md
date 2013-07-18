LINUX SECURITY
==============

Quick Links

* http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers
* http://www.cyberciti.biz/tips/selinux-vs-apparmor-vs-grsecurity.html

[SELinux](http://wiki.debian.org/SELinux), [AppAmmor](http://wiki.debian.org/AppArmor/HowTo), and [grsecurity](http://grsecurity.net/) are all great ways to harden your server.

AppArmor is enabled by default in Ubuntu 7.10+.

## Debian/Ubuntu

```bash
apt-get update
apt-get upgrade
apt-get install fail2ban
```

Add hosts to hosts.allow to prevent accidentally locking yourself out.
Typically, add at least your home or office IP addresses.

```bash
# example hosts.allow
ALL: 1.2.3.4
ALL: 10.10.10.0/24
```


## Configure fail2ban

```bash
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
vim /etc/fail2ban/jail.local
```

** Useful Filters **
* http://serverfault.com/questions/420895/how-to-use-fail2ban-for-nginx


## Setup sudo

```bash
apt-get install sudo
visudo
```

```bash
# sudoers
root    ALL=(ALL) ALL
%sudo  ALL=(ALL) ALL

# Add users to admin group to allow them to sudo
usermod -a -G sudo <user>

# See which users belong to sudo group
grep ^sudo /etc/group
```


## Lockdown SSH

First add your keyless ssh by running the following command from your local machine
(or wherever you have SSH keys already setup).

[Create a strong](http://martin.kleppmann.com/2013/05/24/improving-security-of-ssh-private-keys.html) ssh key.

```bash
# Install ssh-copy-id on OSX
brew install ssh-copy-id

# On machine you're going to ssh from
ssh-copy-id -i ~/.ssh/id_rsa.pub <server ip>
```

Now test to make sure passwordless ssh works

```bash
ssh <server ip>
```

**DO NOT PROCEED** if you're prompted for a password by the server.
This means passwordless ssh was not setup properly.

If everything worked out, edit sshd_config on the server to lockdown ssh.

```bash
vim /etc/ssh/sshd_config
```

Disable root and password authentications.

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
```

Restart sshd

```bash
service ssh restart
```


Setup Firewall

```bash
apt-get install ufw
ufw default deny incoming
ufw default allow outgoing
# allow all private network traffic
# customize or you will lock yourself out!!!
ufw allow from 10.10.10.0/24
ufw enable
```


Setup unattended apt security upgrades

```bash
apt-get install unattended-upgrades
vim /etc/apt/apt.conf.d/10periodic
```

The 10periodic file will not exist. Make it look like ...

```bash
# /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```

Edit 50unattended-upgrades to only auto install security updates by commenting out everything else.

```bash
vim /etc/apt/apt.conf.d/50unattended-upgrades
```

```bash
# /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Allowed-Origins {
  // "${distro_id} stable";
  "${distro_id} ${distro_codename}-security";
};
```


Setup LogWatch

```bash
apt-get install logwatch
vim /etc/cron.daily/00logwatch
```

Add this line

```
/usr/sbin/logwatch --output mail --mailto test@example.com --detail high
```


# Setup SELinux

### References

* http://wiki.debian.org/SELinux/Setup
* https://fedoraproject.org/wiki/SELinux

### Setup for Debian

```bash
apt-get install selinux-basics selinux-policy-default selinux-policy-src auditd
selinux-activate
```

### Configure SELinux

If hosting on DigitalOcean setup kexec to boot with the correct kernel options.
See digitalocean.md

```bash
# Set FSCKFIX to true
vim /etc/default/rcS
set FSCKFIX=yes

# Reboot and check if everything is working
reboot
check-selinux-installation
sestatus

# Ignore /etc/pam.d/login errors reported on Debian wheezy

# See Package Specific fixes for additional security steps
# http://wiki.debian.org/SELinux/Setup
# e.g. removing shadow and gshadow from /etc/cron.daily/passwd

# See all SELinux denied requests
audit2why -al

# If fail2ban is denied access to gam_server change fail2ban backend to polling
vim /etc/fail2ban/jail.local
# backend = polling

# If using custom ssh port, add port to selinux
semanage port -a -t ssh_port_t -p tcp 1234

# List programs protected by SELinux policy
# If a program isn't listed, it's running in unconfined mode which means the program
# can do whatever it wants if it gets exploited
seinfo -t | grep exec_t


# List SELinux booleans
# Booleans are used to turn on and off specific features of policies
getsebool -a

# List security context for a file, user, or process
ls -Z file.foo
id -Z
ps -eZ

# List login user roles
semanage login -l

# Change __default__ to user_u so new user accounts have fewer privileges
semanage login -m -s user_u -r s0 __default__

# Change user mapping for existing user
# Use staff_u for any user that needs sudo privileges...
# http://danwalsh.livejournal.com/18312.html
# WARNING: sudo for staff_u doesn't seem to work properly ... still debugging this
semanage login -a -s user_u joe
semanage login -a -s staff_u joeadmin
# Relabel user's home directory files to match the updated role
restorecon -R -F /home/joe


# Generate a policy template that allows all denied requests since last reboot
# http://docs.fedoraproject.org/en-US/Fedora/13/html/SELinux_FAQ/index.html#id3343680
mkdir /etc/selinux/local && cd /etc/selinux/local
audit2allow -m local -l -i /var/log/audit/audit.log > local.te
checkmodule -M -m -o local.mod local.te
semodule_package -o local.pp -m local.mod
semodule -i local.pp
```

```bash
# Example /etc/selinux/local/local.te generated by audit2allow
# !!! Use at your own risk !!!
# These policies should not be considered secure.
# It's a good idea after package updates to disable policies in local.te by commenting
# them out and recompiling the policy file. Package maintainers periodically fix either
# the package (e.g. exim) or the package's selinux policy file making local policy
# adjustments obsolete.
module local 1.0;
require {
	type fsadm_t;
	type etc_t;
	type iptables_t;
	type sysctl_crypto_t;
	type exim_t;
	type system_mail_t;
	type var_lib_t;
	type proc_t;
	type fail2ban_t;
	type user_home_dir_t;
	class dir search;
	class file { read getattr open write unlink link };
	class filesystem getattr;
}
#============= fsadm_t ==============
allow fsadm_t etc_t:file { write unlink link };
#============= exim_t ==============
allow exim_t sysctl_crypto_t:dir search;
allow exim_t sysctl_crypto_t:file { read getattr open };
allow system_mail_t var_lib_t:file { read getattr open };
#============= iptables_t ==============
allow iptables_t proc_t:filesystem getattr;
#============= fail2ban_t ==============
allow fail2ban_t user_home_dir_t:dir search;
```

```bash
# After updating the local policy, reboot and check audit2why for additional problems

# Once audit2why is empty, enable enforcing mode
vim /etc/selinux/config
SELINUX=enforcing
# Reboot, run sestatus to make sure selinux is enforcing, and check audit2why again
# If everything is working, selinux setup is complete

# If using selinux with VPS, make sure to create the .autorelabel file before creating
# a snapshot of the machine. The file permissions need to be relabeled on first boot
# or else the new VPS won't boot properly.
touch /.autorelabel

# List active modules
semodule -l

# Remove unneeded modules
semodule -r apache
semodule -r git

# To load modules from the default policy
cd /usr/share/selinux/default/
semodule -i <MODULE>.pp

# To restart a service use run_init
# See http://www.crypt.gen.nz/selinux/faq.html
run_init /etc/init.d/sshd restart

# To load existing policy modules that are not currently active
cd usr/share/selinux/default
semodule -i <MODULE>

# To build new policy modules
mkdir newpolicy && cd newpolicy
policygentool <NAME> <PATH TO BIN>
cp /usr/src/selinux-policy-src/doc/Makefile.example ./Makefile
# Customize the policy as needed
vim <NAME>.te
make
semodule -i <NAME>.pp



####################################
# Misc

# Change to a different user role for testing
newrole -r sysadm_r

# If AVC is reporting dac_override errors, it's likely because of a ownership problem
# with a file or directory. To debug, turn on full auditing to see which file is to blame.
# http://danwalsh.livejournal.com/34903.html
echo "-w /etc/shadow -p w" >> /etc/audit/audit.rules
service auditd restart
# Look at audit.log directly since audit2why might not include the path
tail /var/log/audit/audit.log

# Use macros whenever possible instead of allow statements
grep -R <THING_TO_ALLOW> /usr/src/selinux-policy-src/policy/support/
# Look for 'interface' definitions in *.if files
# Pick the macro that allows the fewest permissions first then test

```

# SELinux Resources

* http://wiki.debian.org/SELinux
* http://danwalsh.livejournal.com/
* http://www.selinuxbyexample.com/



# Improve Network Security

* http://www.cyberciti.biz/faq/linux-kernel-etcsysctl-conf-security-hardening/

```bash
vim /etc/sysctl.conf
# See comments in sysctl.conf

# Load sysctl.conf into the running kernel
sysctl -p
```


# Harden Linux

See http://www.debian.org/doc/manuals/securing-debian-howto/ch-automatic-harden.en.html

```bash
apt-get install harden-tools harden-environment harden-servers harden-clients
```




WEB SERVER SECURITY
===================

* http://simonholywell.com/post/2013/04/three-things-i-set-on-new-servers.html
* http://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html

