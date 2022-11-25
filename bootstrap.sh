#!/bin/sh
sysrc linux_enable=YES
kldload linux
pkg install -y tmux vim rsync poudriere git-lite ca_root_nss
echo "NO_ZFS=yes" >> /usr/local/etc/poudriere.conf
mkdir -p /usr/local/poudriere/ports/distfiles 
/usr/local/bin/poudriere jail -c -j 13arm64 -v 13.1-RELEASE 
/usr/local/bin/poudriere ports -c -m git+https
cd /usr/local/etc/poudriere.d/ && fetch https://raw.githubusercontent.com/hackacad/public/607fbd15dbe16807f74d0ec512762516b0db0b8c/131amd64.list
sysrc -f /usr/local/etc/poudriere.conf DISTFILES_CACHE=/usr/local/poudriere/ports/distfiles
/usr/local/bin/tmux new -d -s "poudriere" "/usr/local/bin/poudriere bulk -J 4 -j 13arm64 -f /usr/local/etc/poudriere.d/131amd64.list"
