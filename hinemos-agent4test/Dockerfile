
# Base on official CentOS 7
FROM centos:centos7

LABEL maintainer Pango Chan <Pango853@gmail.com>


# Set Hinemos version. You can replace these with the version you like.
ARG VER=${VER:-6.0}
ARG VERSION=${VERSION:-${VER}.1}

# Set some labels to describe this image
LABEL name="Hinemos Agent ver.$VERSION"
LABEL vendor="Pango853"
LABEL license="MIT"

# Export environment variables
ENV HINEMOSAGTHOME /opt/hinemos_agent

# Install the essential packages and Hinemos, and also clean the yum cache
RUN yum -y install rsyslog net-snmp java-1.8.0-openjdk && \
    rpm -ivh https://github.com/hinemos/hinemos/releases/download/v${VERSION}/hinemos-${VER}-agent-${VERSION}-1.el.noarch.rpm && \
    yum clean all;

ENV PATH $PATH:$HINEMOSAGTHOME/bin

WORKDIR $HINEMOSAGTHOME

EXPOSE 24005/udp 161/udp 22

CMD agent_start.sh -q && tail -f /opt/hinemos_agent/var/log/*.log


# HOW-TO-USE
#	Built it yourself
# 	$ docker build -t hinemos-agent4test .
# 	$ docker run -d hinemos-agent4test
#
#	Or pull it from Docker Hub
#	$ docker pull pango853/hinemos-agent4test
#
#	Better name it
# 	$ docker run -d --name agent001 hinemos-agent4test
#
#	$ docker logs agent001
