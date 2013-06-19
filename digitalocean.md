# Debian Setup

## Hostname

When a new server is created, DigitalOcean adds the hostname to /etc/hosts.

```bash
# /etc/hosts
127.0.0.1    localhost somehostname
```

This works great except for services that use gethostbyname(). System emails like 
bad sudo password notifications will use "localhost" in the emails, making it difficult
to figure out which server actually generated the email.

To make gethostbyname() return the hostname instead of localhost, either move the hostname
to a separate line with the public ip address or move hostname before localhost on the 
127.0.0.1 line.

```bash
127.0.0.1    somehostname localhost
# or
127.0.0.1    localhost
1.1.1.1  somehostname
# Change 1.1.1.1 to the server's public IP address
```


# Debian SELinux

SELinux can be enabled on DigitalOcean by using kexec to load a different kernel, or kernel
configuration options, on boot.

Kexec is required because DigitalOcean (at the time of writing this) boots from a kernel
outside of the VPS, making it impossible to boot natively from a custom kernel. However,
kexec is enabled and works just fine for getting SELinux to run.

http://www.youtube.com/watch?v=LHNPTvMwHPE

```bash
apt-get install kexec-tools
vim /etc/init.d/rcS
```

```
# /etc/init.d/rcS
if grep -qv ' kexeced$' /proc/cmdline ;then
  # Make sure the --append section includes the existing /proc/cmdline options plus selinux
  kexec --load /vmlinuz --initrd=/initrd.img --append=' root=LABEL=DOROOT ro selinux=1 security=selinux kexeced' &&
  mount -o ro,remount / &&
  kexec -e
fi
exec /etc/init.d/rc S
```

## Snapshots

Before taking a snapshot, make sure to create the autorelabel file.
Otherwise, any server created from the snapshot will not properly boot.

```bash
touch /.autorelabel
```

