# Configuration

WIP; samba is slow with the default config

```bash
# Test smb.conf
testparm
```

rlimit_max will likely need to be increased.

```bash
vi /etc/security/limits.conf

# add the following line
* - nofile 16384

# reboot and rerun testparm
```
