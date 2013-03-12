LINUX SECURITY
==============

http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers

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

Setup sudo

```bash
apt-get install sudo
visudo
```

```bash
# sudoers
root    ALL=(ALL) ALL
%admin  ALL=(ALL) ALL
```

Add users to admin group to allow them to sudo

```bash
addgroup admin
usermod -a -G admin <user>
```


Lockdown SSH

First add your keyless ssh by running the following command from your local machine 
(or wherever you have SSH keys already setup).

```bash
# on machine you're going to ssh from
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
service sshd restart
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


Remove mlocate on db or other IO intensive servers

```bash
apt-get purge mlocate
```

