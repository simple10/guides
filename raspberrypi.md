# Internet Sharing Through OSX Laptop

On OSX Laptop:

1. Enable Internet Sharing
  1. System Preferences > Sharing
  2. Share from Wi-Fi to computers using Ethernet
2. Allow Internet Sharing in Firewall
  1. System Preferences > Security
  2. Firewall Options
  3. Uncheck Block All Incoming Connections

On RaspberryPi:

1. Reboot

If Pi is setup to use DHCP, it should get an IP address from OSX laptop like 192.168.2.2.


# Useful Commands

```bash
# Reconfigure pi settings like memory, overclocking, etc
sudo raspi-config
```


# Initial Setup

### On RaspberryPi

```bash
# Make sure everything is up to date
sudo apt-get update
sudo apt-get upgrade

# Install useful tools
apt-get install htop chkconfig tmux

# Add a user for yourself instead of the default pi user
sudo adduser joe
# Add new user to sudo group
sudo usermod -a -G sudo joe
# Disable login for the default pi user
sudo usermod -e 1 -L pi
# Remove pi from sudo group
sudo gpasswd -d pi sudo

# Remove pi user from sudoers
sudo visudo
# Comment out the following line
# pi ALL=(ALL) NOPASSWD: ALL
```


### On OSX Laptop

```bash
# Install ssh-copy-id
brew install ssh-copy-id

# See ssh.md guide if you need to generate a private key

# Copy over public key
ssh-copy-id -i ~/.ssh/id_rsa.pub <raspberrypi ip> -p 1234

# Test passwordless login
ssh joe@<raspberrypi ip> -p 1234
```


### On RaspberryPi (continued)

```bash
# Harden ssh
sudo vi /etc/ssh/sshd_config

  Port 1234 # Or choose something more unique
  PasswordAuthentication no
  PermitRootLogin no

# Update services file with new ssh port
sudo vi /etc/services

  ssh    1234/tcp

# Restart ssh
sudo service ssh restart

# Install ufw to manage firewall rules
sudo apt-get install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
sudo ufw status verbose

# Install fail2ban to ban IP addresses that attempt to brute force attach ssh
sudo apt-get install fail2ban

# Increase max open files limit since debian sets it too low by default
sudo vi /etc/sysctl.conf

  # Add this to the end
  fs.max-file = 100000

# Reboot to make sure everything is working as expected
sudo reboot
```


# Install BitTorrent Client

Use [Deluge](http://deluge-torrent.org/) since uTorrent is not well supported on RaspberryPi.

http://www.howtogeek.com/142044/how-to-turn-a-raspberry-pi-into-an-always-on-bittorrent-box/

The Deluge packages for Debian 7.0 (wheezy) are missing a few important features like being
able to use magnet URLs in the webui. If these features are needed, install deluge from
source otherwise just use apt-get.

```bash
# Get source
wget http://download.deluge-torrent.org/source/deluge-1.3.6.tar.gz
tar -xzf deluge-1.3.6.tar.gz
cd deluge-1.3.6

# Install dependencies
sudo apt-get install python python-twisted python-twisted-web python-openssl python-simplejson python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako

# Create a user and group
sudo adduser --system --home /home/deluge --group deluge

# Run deluge to create the config files in /home/deluge/.config/deluge
sudo -u deluge deluged
sudo pkill deluged
sudo -u deluge deluge-web
sudo pkill deluge-web

# Setup init.d script
sudo wget -O /etc/init.d/deluged https://raw.github.com/simple10/guides/master/etc/init.d/deluged
sudo chmod 755 /etc/init.d/deluged
sudo chkconfig deluged on --level 2345

# Edit config files as needed
sudo vi /home/deluge/.config/deluge/core.conf
# Change move_completed_path, torrentfiles_location, and download_location to use external drive
# example: /data/downloads
# Change autoadd_location to a torrents directory on external drive
# example: /data/torrents
# Change proxies settings to use TorGuard or BTGuard
# Use type=3 for Socks5 with Auth
# Change port range from 6881,6889 to something between 49152 and 65535 to get around ISP throttling
sudo vi /home/deluge/.config/deluge/web.conf
# Set https to true

# Update ufw deluge application with custom ports
sudo vi /etc/ufw/applications.d/ufw-bittorrent

   # Open up bittorrent listening ports
   [Deluge]
   title=Deluge
   description=Deluge BitTorrent client
   # Change ports to whatever was configured in core.conf
   ports=8112/tcp|49351:49359/tcp|49351:49359/udp

sudo ufw allow Deluge

# Start the deluge daemon and web client
sudo service deluged start

# Check the logs
sudo tail /home/deluge/.config/deluge/deluge.log

# Reboot to make sure the daemon comes online properly
sudo reboot

# From another computer, access the webui
# The SSL cert will give a warning and can be ignored
https://192.168.2.2:8112
# Default password is "deluge"
```

# Firewall Issues

Open Preferences > Network in the webui or edit core.conf.

1. Uncheck random ports for Incoming Ports
2. Assign incoming ports
  * ex: 49351 - 49359
3. Disable UPnP and NAT-PMP

Assign a static IP address to the RaspberryPi. See Static IP section below.

In your router, forward ports (ex: 49351-49359) tcp and udp to the pi's IP address.

On the pi, make sure the firewall allows for incoming connections.

```bash
sudo ufw status verbose
# Should show something like...

  49351:49359/tcp (Deluge)   ALLOW IN    Anywhere
  49351:49359/udp (Deluge)   ALLOW IN    Anywhere

```

Now watch the webui or deluge console to see if bits are being uploaded.


# Mount OSX Journaled Drives

If a drive was initially formatted on OSX with journaling enabled, do the following
to properly mount the drive.

```bash
sudo apt-get install hfsprogs

# Manually unmount and mount the drive to test settings
sudo umount /dev/sda2
mkdir /data
sudo mount -t hfsplus -o defaults,force /dev/sda2 /data

# Get uuid of drive
sudo blkid /dev/sda2

# Add drive to fstab to always mount with hfsplus
sudo vi /etc/fstab

  # Change UUID to value from blkid
  UUID=d537ce5a-a287-3b3a-a23c-4bd6eb1aaf4e /data hfsplus defaults,force 0 0

# Reboot and verify
reboot

cd /data
touch test.txt
```


# Set Static IP Address

```bash
sudo vi /etc/networking/interfaces

  #iface eth0 inet dhcp
  iface eth0 inet static
    address 192.168.0.99
    netmask 255.255.255.0
    gateway 192.168.0.1

ifdown eth0 && ifup eth0
```

# Setup SAMBA

http://www.howtogeek.com/139433/how-to-turn-a-raspberry-pi-into-a-low-power-network-storage-device/

```bash
sudo apt-get install samba samba-common-bin
sudo vi /etc/samba/smb.conf
sudo service samba restart
sudo ufw allow CIFS
```


# Add Debian Sources

This is just here for future reference. I tried to use the deluge packages in experimental
but deluge wouldn't start and no output was shown to aid in debugging.

```bash
# Add debian experimental sources
echo "echo 'deb http://ftp.debian.org/debian experimental main' >> /etc/apt/sources.list" | sudo sh
apt-key adv --keyserver pgp.mit.edu --recv-key AED4B06F473041FA # squeeze
apt-key adv --keyserver pgp.mit.edu --recv-key 8B48AD6246925553 # wheezy
sudo apt-get update

# Install package
sudo apt-get install -t experimental <package>
```


# Removing Deluge

```bash
# If installed as a package
apt-get purge deluge-common deluge-console deluged geoip-database libboost-filesystem1.49.0 libboost-python1.49.0 libboost-system1.49.0 libboost-thread1.49.0 libgeoip1 libtorrent-rasterbar6 python-chardet python-libtorrent python-openssl python-pam python-pkg-resources python-serial python-twisted-bin python-twisted-core python-twisted-web python-xdg python-zope.interface deluge-web python-mako python-markupsafe

# If installed from source
autoconf automake autopoint autotools-dev geoip-database gettext intltool javascript-common libboost-filesystem1.49.0 libboost-python1.49.0 libboost-system1.49.0 libboost-thread1.49.0 libencode-locale-perl libfile-listing-perl libfont-afm-perl libgeoip1 libgettextpo0 libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libio-socket-ip-perl libio-socket-ssl-perl libjs-jquery liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-http-perl libnet-ssleay-perl libsocket-perl libtorrent-rasterbar6 libunistring0 liburi-perl libwww-perl libwww-robotrules-perl libxml-parser-perl m4 python-cairo python-chardet python-crypto python-glade2 python-gobject-2 python-gtk2 python-libtorrent python-mako python-markupsafe python-notify python-openssl python-pam python-pkg-resources python-pyasn1 python-serial python-setuptools python-simplejson python-twisted python-twisted-bin python-twisted-conch python-twisted-core python-twisted-lore python-twisted-mail python-twisted-names python-twisted-news python-twisted-runner python-twisted-web python-twisted-words python-xdg python-zope.interface wwwconfig-common
# Then manually remove deluge??? Or does the setup script have an uninstall???
```
