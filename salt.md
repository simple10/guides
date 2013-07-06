Consider Anisble instead???

http://missingm.co/2013/06/ansible-and-salt-a-detailed-comparison/


# Setup Salt

```bash
apt-get update
apt-get upgrade
apt-get install debconf-utils
apt-get install python-pip
wget -O - http://bootstrap.saltstack.org | sudo sh

# Create /srv/salt/ files for installing nginx
echo "base:
  '*':
    - webserver
" > /srv/salt/top.sls
echo "nginx:
  pkg:
    - installed
" > /srv/salt/webserver.sls

# Start salt in masterless mode
salt-call --local state.highstate -l debug

# After setup, uninstall pip and the packages it installed for added security
apt-get purge build-essential cpp cpp-4.7 dpkg-dev fakeroot g++ g++-4.7 gcc gcc-4.7 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libc-dev-bin libc6-dev libdpkg-perl libfile-fcntllock-perl libitm1 libmpc2 libmpfr4 libquadmath0 libstdc++6-4.7-dev libtimedate-perl linux-libc-dev make manpages-dev python-setuptools python2.6

```


# Salt Cloud

?????? How to use salt cloud with masterless minions?

```bash
apt-get install salt-minion
pip install apache-libcloud
pip install salt-cloud

vim /etc/salt/cloud.providers.d/digitalocean.conf

	digitalocean:
		provider: digital_ocean
		client_key: [CLIENT KEY]
		api_key: [API KEY]
		location: San Francisco 1
		image: 308287 # Debian 7.0 x64
		size: 66 # 512 MB instance


# List images
salt-cloud --list-images digitalocean

```