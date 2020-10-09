# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
# https://github.com/justb4/docker-jmeter/blob/master/Dockerfile
FROM alpine:3.12

MAINTAINER Marco Bernasocchi<marco@opengis.ch>

ARG AGENT_VERSION="2.2.3"
ENV	DOWNLOAD_URL  https://github.com/undera/perfmon-agent/releases/download/${AGENT_VERSION}/ServerAgent-${AGENT_VERSION}.zip

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${DOWNLOAD_URL} >  /tmp/dependencies/agent.zip \
	&& mkdir -p /opt  \
	&& unzip /tmp/dependencies/agent.zip -d /opt  \
	&& rm -rf /tmp/dependencies

EXPOSE 4444

WORKDIR	/opt/ServerAgent-${AGENT_VERSION}
CMD ./startAgent.sh --interval 5
