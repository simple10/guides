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

# Disable Printers

```bash
# Add to /etc/samba/smb.conf

   load printers = no
   printing = bsd
   printcap name = /dev/null
   show add printer wizard = no
   disable spoolss = yes
```

# Performance Tuning

- https://wiki.samba.org/index.php/Linux_Performance
- http://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/speed.html
- http://www.eggplant.pro/blog/faster-samba-smb-cifs-share-performance/
- enable [jumbo frames](https://wiki.archlinux.org/index.php/Jumbo_frames) on server
- tweak osx client [delayed_ack param](https://community.emc.com/message/771176)


```bash
# Add to /etc/samba/smb.conf

# Performance tweaks
   socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
   min receivefile size = 16384
   use sendfile = true
   aio read size = 16384
   aio write size = 16384
   max xmit = 65536
   read raw = yes
   write raw = yes
   strict allocate = yes
   strict locking = auto
;   max connections = 65535
;   max open files = 65535
```


# Test

Test speed with rsync or pv:
http://askubuntu.com/questions/17275/progress-and-speed-with-cp

```bash
# Example for samba "backup" folder mounted on OSX
rsync -av --progress [SOURCE_FILE] /Volumes/backup
```
