* http://ansibleworks.com/docs/gettingstarted.html
* http://missingm.co/2013/06/ansible-and-salt-a-detailed-comparison/


Use ssh for ANSIBLE_TRANSPORT to enable use of OpenSSH instead of paramiko.
Make sure ControlMaster options are set to enable fast transport.

Ansible 1.2.1+ will try to use ssh first and default back to paramiko if 
OpenSSH does not support ControlPersist.

http://ansibleworks.com/docs/gettingstarted.html#choosing-between-paramiko-and-native-ssh


```bash
# Get requirements
apt-get install python-jinja2
apt-get install python-yaml
apt-get install checkinstall

# Get ansible
git clone git://github.com/ansible/ansible.git
cd ansible

# Install as debian package for easy uninstall
checkinstall
# Modify description, version, etc. if desired or leave blank

mkdir /etc/ansible
vim /etc/ansible/hosts
# Add hosts

# Test connection to machines defined in hosts file
ansible all -m shell -a "ls -l"
```


# Cleanup

```bash
# Uninstall new packages installed by checkinstall
apt-get purge build-essential checkinstall cpp cpp-4.7 dpkg-dev fakeroot g++ g++-4.7 gcc gcc-4.7 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libc-dev-bin libc6-dev libdpkg-perl libfile-fcntllock-perl libgmp10 libitm1 libmpc2 libmpfr4 libquadmath0 libstdc++6-4.7-dev libtimedate-perl linux-libc-dev manpages-dev
```
