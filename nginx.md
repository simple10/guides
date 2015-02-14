https://t37.net/nginx-optimization-understanding-sendfile-tcp_nodelay-and-tcp_nopush.html

[Nginx in Docker](https://news.ycombinator.com/item?id=9045125) - issues with sendfile in shared file system

http://blog.zachorr.com/nginx-setup/

http://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html

# Install the naxsi enabled version of Nginx
apt-get install nginx-naxsi
vim /etc/nginx/nginx.conf

# Set server tokens to off to prevent nginx version from being exposed
server_tokens off;



# Harden with SELinux

apt-get install selinux-policy-dev
# cd ~/
# wget http://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html
git clone <path to simple10 nginx policy>


# Nginx policy needs httpd_sys_content_t which is defined in the apache module
cd /usr/share/selinux/default
semodule -i apache.pp


After installing ..
touch /.autorelabel
reboot
# This will set the file perms specified in nginx.fc


# Turn off nginx auto startup
chkconfig nginx off
# Add nginx file to monit
# [...]

# Setup naxsi
vim /etc/nginx/nginx.conf
# Uncomment: include /etc/nginx/naxsi_core.rules;
vim /etc/nginx/sites-enabled/default
# Add: include /etc/nginx/naxsi.rules;
service nginx reload

# [optional] Install naxsi UI to monitor and config nasxi through the web
apt-get install nginx-naxsi-ui

# Open port 80 in the firewall
ufw allow 80/tcp


# Monitoring

See [Monitor Guide](https://github.com/simple10/guides/blob/master/monitor.md)
