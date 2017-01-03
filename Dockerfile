FROM phusion/baseimage:0.9.16
ENV DEBIAN_FRONTEND noninteractive

COPY src/excludes /root/

# set startup file
RUN \
# update apt and install dependencies
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
add-apt-repository ppa:nathan-renniewaldock/qdirstat && \
apt-get update && \
apt-get install -y --force-yes --no-install-recommends wget openjdk-7-jre supervisor sudo nano net-tools lxde x11vnc xvfb gtk2-engines-murrine ttf-ubuntu-font-family firefox lxterminal && \
apt-get install -y xrdp gnome-terminal qdirstat && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

# Add local files
COPY src/ /root/

# Set correct environment variables
ENV HOME /root
ENV TERM xterm
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# set workdir 
WORKDIR /

# Expose ports 
EXPOSE 6080
EXPOSE 5900
EXPOSE 3389

RUN  \
mv /root/firstrun.sh /etc/my_init.d/firstrun.sh && \
chmod +x /etc/my_init.d/firstrun.sh && \
# create ubuntu user
#useradd --create-home --shell /bin/bash --user-group --groups root,adm,sudo ubuntu && \

# set user ubuntu to root group
#usermod -u 0 ubuntu && \
#usermod -g 0 ubuntu && \


# swap in modified xrdp.ini
mv /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.original && \
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \
chown root:root /etc/xrdp/xrdp.ini
