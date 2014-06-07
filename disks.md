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

## Formatting Disk

[BTRFS](http://www.howtoforge.com/a-beginners-guide-to-btrfs)

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
# Add disk with UUID
# UUID=5fde56d0-b290-428c-6a3d-6787d3705c00 /data           btrfs   defaults        0       1

```

