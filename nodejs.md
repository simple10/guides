# Debugging

* [Node Inspector](https://github.com/node-inspector/node-inspector)
* [Built in debugger](http://nodejs.org/api/debugger.html) – `node debug script.js`
* [StackOverflow discussion](http://stackoverflow.com/questions/1911015/how-to-debug-node-js-applications)
* [Node debugging primer](http://www.habdas.org/node-js-debugging-primer/)

# Debian

```bash
apt-get install build-essential checkinstall

adduser --system --no-create-home --home /srv/node --group nodejs
# Map nodejs user to SELinux user_u to limit privileges
semanage login -a -s user_u -r s0 nodejs
# Update ownership node dir
chown -R nodejs:nodejs /srv/node

wget -N http://nodejs.org/dist/node-latest.tar.gz
tar xzvf node-latest.tar.gz && cd node-v*

# Configure node to install in /opt/node
./configure --prefix=/opt/node

# If using SELinux, temporarily allow execstack
setsebool allow_execstack 1

# Create a dpkg package and install it
# Remove the "v" in front of the version number in the dialog
checkinstall 

# Turn off execstack
setsebool allow_execstack 0

# uninstall 
dpkg -r node

# reinstall
dpkg -i node_*

# Add /opt/node/bin to PATH
vim /etc/profile
PATH=$PATH:/opt/node/bin

# Add /opt/node/bin to sudo secure_path
visudo
Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/node/bin"

# Setup init.d script
# See /etc/init.d/nodejs
# Make sure node pid directory exists
mkdir -Z system_u:object_r:initrc_var_run_t:SystemLow node
```



## !!!!!! need security info about npm packages
## !!!!!! sudo npm install?  what about ownership of files as selinux?

As of v0.3, it's recommended to run npm as root. Npm will automatically downgrade to the nobody 
user while building and testing packages.

sudo npm install


## Create SELinux Policy

```bash
apt-get install selinux-policy-dev
policygentool nodejs /opt/node/bin

# Modify the nodejs.te file as needed

# Make and install policy
make
semodule -i nodejs.pp
```


## Remove Packages Installed by build-essentials and checkinstall

```
apt-get purge build-essential checkinstall

apt-get purge cpp cpp-4.7 dpkg-dev fakeroot g++ g++-4.7 gcc gcc-4.7 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libc-dev-bin libc6-dev libdpkg-perl
libfile-fcntllock-perl libgmp10 libitm1 libmpc2 libmpfr4 libquadmath0 libstdc++6-4.7-dev libtimedate-perl linux-libc-dev manpages-dev

apt-get autoremove --purge
```

# Production Node.js

* Use cluster module
  * Master monitors and kill workers
  * Workers die early on errors
* Or use [pm2](https://github.com/Unitech/pm2) to manage workers
* Use [monit](http://mmonit.com/monit/) to keep node alive
* Use [nvm](https://github.com/creationix/nvm) or [nave](https://github.com/isaacs/nave/) if multiple versions of node are needed

# Reference

[Deploying Node.js with Systemd](http://savanne.be/articles/deploying-node-js-with-systemd/)

* Alternative to monit or forever
* Systemd is not installed on Debian by default



