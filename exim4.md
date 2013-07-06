sudo dpkg-reconfigure exim4-config


mail sent by smarthost; no local mail
system mail name: example.com
ip for incoming: 127.0.0.1 ; ::1
other destinations: [blank]
visible domain: example.com
ip of outgoing: smtp.mandrillapp.com::587
dns queries: no
split: no
root recipient: [blank]


vim exim4.conf.localmacros
MAIN_TLS_ENABLE = 1

vim password.client
*:<username>:<pass>

sudo update-exim4.conf
sudo service exim4 restart


exim -v test@example.com
Subject: hi

hi!
^D
-----


# Add local user forwarding addresses as needed
vim /etc/email-addresses
# e.g. root: joe@example.com

