#!/bin/sh

#Let's fix/finish postfix installation for `postqueue -p` to work
touch /postfix-files
mkdir /usr/lib/postfix/lib
/usr/lib/postfix/sbin/post-install daemon_directory=/usr/lib/postfix create-missing
