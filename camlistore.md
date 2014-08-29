# Install

For Debian and Ubuntu.

1. Follow camlistore instructions for installing required golang version
2. Install camlistore source code into /usr/src/camlistore

```bash
# Symlink camlistored
ln -s /usr/src/camlistore/bin/camlistored /usr/local/bin/camlistored

# Create camlistore user
sudo adduser --system --group --home /var/lib/camlistore --shell /bin/bash camlistore

# Generate default config files by running camlistored for the first time
sudo su - camlistore
camlistored
exit

# Remove shell access for camlistore user
sudo usermod -s /bin/false camlistore

# Add init.d/camlistore script
sudo curl -o /etc/init.d/camlistore https://raw.githubusercontent.com/simple10/guides/master/etc/init.d/camlistore
sudo chmod 755 /etc/init.d/camlistore

# Start camlistored service
sudo service camlistore start

# Open firewall
echo "camlistore      3179/tcp" | sudo tee -a /etc/services
sudo ufw allow camlistore
```

