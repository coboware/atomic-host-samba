FROM alpine:latest
LABEL MAINTAINER="coboware" 

# upgrade base system and install samba, avahi and supervisord
# add a non-root user and group called "share" with no password, no home dir, no shell, and gid/uid set to 1000
# create a dir for share

RUN apk update && apk upgrade && \
  apk add samba samba-common-tools avahi avahi-tools supervisor && \
  addgroup -g 1000 share && adduser -D -H -G share -s /bin/false -u 1000 share && \
  mkdir /share && \
  rm -rf /var/cache/apk/*

# copy config files from project folder to get a default config going for samba and supervisord
COPY smb.conf /etc/samba/smb.conf
COPY supervisord.conf /etc/supervisord.conf

# daemon
USER share

# create a samba user matching our user from above with a very simple password ("letsdance")
RUN echo -e "share\nshare" | smbpasswd -a -s -c /etc/samba/smb.conf share && \
  sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf

# volume mappings
VOLUME /share

# exposes samba's default ports (137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 137/udp 138/udp 139 445 5353/udp

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
