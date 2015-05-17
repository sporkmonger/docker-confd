FROM ubuntu:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

ENV CONFD_VERSION=0.9.0 CONFD_HASH="43075b02ea86efea287914ecd26383a880dcbe636da1b658235274ca906768ae28b09721f12a0a8dd9decd7e455c4228d619439459aa7a1eef9db70d4b02dd8e"

# Update and install supervisor
RUN apt-get update && \
	apt-get install -y supervisor && \
	rm -rf /var/lib/apt/lists/*

# Get and install confd
ADD https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 /tmp/
RUN mv /tmp/confd-$CONFD_VERSION-linux-amd64 /opt/bin/confd && \
	mkdir -p /etc/opt/hashes/ && \
	sh -c '/usr/bin/echo "$CONFD_HASH  /opt/bin/confd" > /etc/opt/hashes/confd.sha512' && \
	sha512sum -c /etc/opt/hashes/confd.sha512 && \
	chmod a+x /opt/bin/confd && \
	mkdir -p /etc/confd/{conf.d,templates}

# Add the start script
ADD start /opt/bin/

CMD [ "/opt/bin/start" ]
