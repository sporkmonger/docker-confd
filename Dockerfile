FROM ubuntu:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

ENV CONFD_VERSION=0.9.0 \
	CONFD_HASH="43075b02ea86efea287914ecd26383a880dcbe636da1b658235274ca906768ae28b09721f12a0a8dd9decd7e455c4228d619439459aa7a1eef9db70d4b02dd8e" \
	GITHUB_FINGERPRINT="A0:C4:A7:46:00:ED:A7:2D:C0:BE:CB:9A:8C:B6:07:CA:58:EE:74:5E" \
	AWS_S3_FINGERPRINT="93:7B:CB:77:46:37:85:0B:D5:70:E5:A3:03:5A:F0:D8:92:9F:03:88"

# Update and install supervisor
RUN apt-get update && \
	apt-get install -y supervisor && \
	apt-get install -y curl && \
	rm -rf /var/lib/apt/lists/*

# Get and install confd, with key pinning
RUN mkdir -p /opt/bin/ && \
	openssl s_client -connect github.com:443 < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin | grep "$GITHUB_FINGERPRINT" && \
	openssl s_client -connect s3.amazonaws.com:443 < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin | grep "$AWS_S3_FINGERPRINT" && \
	curl -L -o /opt/bin/confd https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64
	mkdir -p /etc/opt/hashes/ && \
	sh -c 'echo "$CONFD_HASH  /opt/bin/confd" > /etc/opt/hashes/confd.sha512' && \
	sha512sum -c /etc/opt/hashes/confd.sha512 && \
	mkdir -p /etc/confd/{conf.d,templates}

# Note that this is not the correct way to do key pinning.
# The latest version of curl on Ubuntu is 7.35, while real
# key pinning on curl is part of the 7.39 release, which
# isn't available on any version of Ubuntu yet. We're using
# poor-man's key pinning instead and backing it up w/ a
# SHA512 hash over the entire binary. The pin here provides
# little real security beyond a sanity check and a gotcha
# for a particularly careless MITM. Gentoo has the latest
# version of curl and might be a better base image option
# here given the security concerns.

# Add the start script
ADD start /opt/bin/

# Set permissions
RUN chmod a+x /opt/bin/confd /opt/bin/start

CMD [ "/opt/bin/start" ]
