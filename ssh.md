# Client

```bash
# Exit a stuck ssh or terminal session
~.ENTER
```

Generate a new ssh key.

```bash
# Simple way
ssh-keygen -t rsa -b 4096 -C "name@domain.com"

# OR old way...

ssh-keygen -t rsa -C "yourname@yourdomain.ext"

# Make the key much stronger
# This protects against someone stealing the key and brute force decrypting it
# http://martin.kleppmann.com/2013/05/24/improving-security-of-ssh-private-keys.html
mv ~/.ssh/id_rsa ~/.ssh/id_rsa.old
openssl pkcs8 -topk8 -v2 des3 -in ~/.ssh/id_rsa.old -out ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
# Test the new key by ssh'ing into a server
# Make sure to remove the old key!!!
rm ~/.ssh/id_rsa.old
```

Copy a local key to a remote server to allow for passwordless login.
After copying the key, disable password logins on the server.

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub <server ip>
```


Add visual host keys to ssh by default to help protect against MITM attacks.

```bash
# ~/.ssh/config
Host *
  VisualHostKey yes
```


Use ssh-agent to remember credentials and avoid entering a password every time.

```bash
ssh-agent bash
ssh-add ~/.ssh/id_rsa
```
