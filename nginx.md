http://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html


apt-get install nginx
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
# Turn it on
chkconfig nginx on --level 2345

# Open port 80 in the firewall
ufw allow 80/tcp
