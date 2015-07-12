FROM quay.io/sporkmonger/secure-bootstrap:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

RUN mkdir -p /opt/bin/ && \
	mkdir -p /etc/confd/{conf.d,templates}

# Move confd into place
ADD confd /opt/bin/

# Add the start script
ADD start /opt/bin/

# Set permissions
RUN chmod a+x /opt/bin/confd /opt/bin/start

# Make sure everything is up-to-date
RUN /opt/bin/cveck

CMD [ "/opt/bin/start" ]
