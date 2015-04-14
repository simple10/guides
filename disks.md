# Debian/Ubuntu

How to mount external USB disks.

[Ubuntu Guide](https://help.ubuntu.com/community/Mount/USB)

```bash
# List available disks
fdisk -l

# Create the mount point
mkdir /data

# Mount the disk
# See guide
```

# BTRFS

- [BTRFS](http://www.howtoforge.com/a-beginners-guide-to-btrfs)
- [Why use btrfs?](https://www.youtube.com/watch?v=6DplcPrQjvA) - Jan 2015 talk from Google engineer
  - licensing + better memory usage on linux
  - use kernel [3.14.x](http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.14.1-trusty/), avoid 3.15-3.16.1 (9:30 in video)
    - download deb packages for headers and image, then `dpkg -i *.deb`
  - always have backups, possibility of corruption
  - file encryption not yet supported, can use dm-crypt
  - dedup is available via experimental userland tool
  - use `chattr +C /path` to turn off CoW for a file or dir
  - defrag is slow, better to cp to new file and delete old:
    - `cp -reflink=never file.orig file.new && rm file.orig`
  - use `cp -reflink src dest` to copy a file or dir without duplicating underlying blocks
  - use btrfs [send/receive](http://marc.merlins.org/perso/btrfs/post_2014-03-22_Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive.html) instead of rsync (31:09 in video)


```bash
apt-get install btrfs-tools

# Init filesystem as a single disk if hardware RAID is used 
mkfs.btrfs -m single /dev/sdb

# Inspect
btrfs filesystem show

# Mount
mkdir /data
mount /dev/sdb /data

# Inspect
df -h

# Update fstab to add new disk to auto mount on boot
blkid
# Copy UUID of /dev/sdb

vim /etc/fstab
# OR vifs if available

# Add disk with UUID
# UUID=5fde56d0-b290-428c-6a3d-6787d3705c00 /data           btrfs   defaults        0       1

```

