#!/bin/bash
echo "setting password"
echo "root:$PASSWD" | chpasswd

if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

mkdir -p /home/root/unraid
mkdir -p /home/root/.config/pcmanfm/LXDE
if [ -d "/home/root/unraid/wallpapers" ]; then
echo "using existing wallpapers etc..."
else
mkdir -p /home/root/unraid/wallpapers
cp /root/wallpapers/* /home/root/unraid/wallpapers/
mv  /root/desktop-items-0.conf /home/root/.config/pcmanfm/LXDE/desktop-items-0.conf
chown ubuntu:users /home/root/.config/pcmanfm/LXDE/desktop-items-0.conf
chmod 644 /home/root/.config/pcmanfm/LXDE/desktop-items-0.conf
fi

mkdir  /var/run/sshd
mkdir  /root/.vnc
/usr/bin/supervisord -c /root/supervisord.conf
while [ 1 ]; do
/bin/bash
done
