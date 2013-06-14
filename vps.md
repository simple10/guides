Assumes Debian or Ubuntu.

Login as root

```bash
# COPY AND PASTE
apt-get update
apt-get upgrade
apt-get install fail2ban
apt-get install ufw
apt-get install chkconfig
```

```bash
# INTERACTIVE

# Copy and paste the below .bashrc file
vim /etc/skel/.bashrc

# Create admin user "joe"
adduser joe
# Add joe to sudo group
usermod -a -G sudo joe

# Authorize joe to login using ssh keys
# From a machine that already has joe's pub key...
ssh-copy-id -i ~/.ssh/id_rsa.pub joe@<SERVER IP>

# Verify sudo group is setup properly
visudo
# Should look like...
# %sudo   ALL=(ALL:ALL) ALL
# See security.md guide for more details

# Test logging in without a password
ssh joe@<SERVER IP> -p 2222
# Test sudo
sudo su -

# Disable password and root ssh and optionally change port
vim /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
# Port 2222
service ssh restart

# Update ssh port in /etc/services if changed in /etc/ssh/sshd_config
vim /etc/services
# ssh             2222/tcp
# ssh             2222/udp

# Cleanup
rm -rf /root/.ssh

# Setup firewall
ufw default deny incoming
ufw default allow outgoing
# Allow ssh on whatever port you set in sshd_config
ufw allow ssh
ufw enable
ufw status verbose
# See https://help.ubuntu.com/community/UFW

# Configure fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
vim /etc/fail2ban/jail.local
# Modify destemail and enable services as needed
# Restart fail2ban
service fail2ban restart

# Setup unattended security upgrades
# See security.md guide
```






# Database or IO Intensive Servers

```bash
# Disable mlocate
apt-get purge mlocate
```






# Customized .bashrc

Copy to /etc/skel/.bashrc and any existing user directories.

```bash
# cat /etc/skel/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;33m\]\w \[\033[01;31m\][remote] \[\033[01;33m\]\h \n\$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
export LS_OPTIONS='--color=auto'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls $LS_OPTIONS'
    alias dir='dir $LS_OPTIONS'
    alias vdir='vdir $LS_OPTIONS'

    alias grep='grep $LS_OPTIONS'
    alias fgrep='fgrep $LS_OPTIONS'
    alias egrep='egrep $LS_OPTIONS'
fi

# some more ls aliases
alias ll='ls -l $LS_OPTIONS'
alias la='ls -la $LS_OPTIONS'
alias l='ls -CF $LS_OPTIONS'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# alias vim.tiny if vim doesn't exist
if [ ! -x /usr/bin/vim ]; then
    alias vim='vim.tiny'
fi
```
