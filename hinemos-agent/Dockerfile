# Base on official CentOS 7
FROM centos:centos7

LABEL maintainer Pango Chan <Pango853@gmail.com>


# First add a helper script
COPY scripts/updateandstartagent.sh /usr/local/bin
RUN chmod +x /usr/local/bin/updateandstartagent.sh

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
    rpm -ivh https://github.com/hinemos/hinemos/releases/download/v${VERSION}/hinemos-${VER}-agent-${VERSION}-1.el.noarch.rpm; \
    yum clean all;


WORKDIR $HINEMOSAGTHOME

# Copy as a new startup script without nohup
RUN grep -B9999 '^CMD=' bin/agent_start.sh | sed -e 's/nohup //' -e 's/QUIET=0/QUIET=1/' > bin/start.sh && \
    echo '$CMD' >> bin/start.sh && \
    chmod +x bin/start.sh

#ENV PATH $PATH:$HINEMOSAGTHOME/bin

EXPOSE 24005/udp 161/udp 22

ENTRYPOINT ["updateandstartagent.sh"]

# HOW-TO-USE
#	Built it yourself
# 	$ docker build -t hinemos-agent .
# 	$ docker run -d hinemos-agent
#
#	Or pull it from Docker Hub
#	$ docker pull pango853/hinemos-agent
#
#	Better name it
# 	$ docker run -d --name agent001 -e MANAGER_IP_ADDRESS=172.17.0.2 hinemos-agent
#
#	$ docker logs agent001
#       $ docker exec agent001 ip addr show

