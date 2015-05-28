FROM quay.io/sporkmonger/secure-bootstrap
MAINTAINER Bob Aman <bob@sporkmonger.com>

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/bin/ && \
	mkdir -p /etc/confd/{conf.d,templates}

# Move confd into place
ADD confd /opt/bin/

# Add the start script
ADD start /opt/bin/

# Set permissions
RUN chmod a+x /opt/bin/confd /opt/bin/start

# I just can't deal with terminals that don't have pretty colors.
ENV PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] " \
  TERM="xterm-color"

CMD [ "/opt/bin/start" ]
