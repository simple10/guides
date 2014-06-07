# Debian/Ubuntu

How to mount external disks.

[Ubuntu Guide](https://help.ubuntu.com/community/Mount/USB)

```bash
# List available disks
fdisk -l

# Create the mount point
mkdir /data

# Mount the disk
# See guide
```

## Formatting Disk

[BTRFS](http://www.howtoforge.com/a-beginners-guide-to-btrfs)

```bash
apt-get install btrfs-tools

# Init filesystem as a single disk if hardware RAID is used 
mkfs.btrfs -m single /dev/sdb

# Inspect
btrfs filesystem show
