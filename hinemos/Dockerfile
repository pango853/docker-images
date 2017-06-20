
# Base on official CentOS 7
FROM centos:centos7

LABEL maintainer Pango Chan <Pango853@gmail.com>

# First add a helper script
COPY scripts/hinemos_check_and_update_listen_address.sh /usr/local/bin
RUN chmod +x /usr/local/bin/hinemos_check_and_update_listen_address.sh

# Set Hinemos version. You can replace these with the version you like.
ARG VER=${VER:-6.0}
ARG VERSION=${VERSION:-${VER}.1}

# Set some labels to describe this image
LABEL name="Hinemos $VER"


# Export environment variables
ENV HINEMOSHOME /opt/hinemos
ENV PGHOME $HINEMOSHOME/postgresql
ENV PGDATA $HINEMOSHOME/var/data
ENV HINEMOSWEBHOME /opt/hinemos_web

# Environment variables with default values
ENV PGPORT 24001
ENV PGDATABASE hinemos
ENV PGUSER hinemos
ENV PGPASSWORD hinemos
ENV AUTOIPFIX 1

# Optional variables
ENV PGCONNECT_TIMEOUT 90
ENV LANG en_US.UTF-8

# Install the essential packages and Hinemos, and also clean the yum cache
RUN yum -y install rsyslog net-snmp java-1.8.0-openjdk java-1.8.0-openjdk-devel wget unzip net-tools vim-common && \
    rpm -ivh https://github.com/hinemos/hinemos/releases/download/v${VERSION}/hinemos-${VER}-manager-${VERSION}-1.el7.x86_64.rpm && \
    rpm -ivh https://github.com/hinemos/hinemos/releases/download/v${VERSION}/hinemos-${VER}-web-${VERSION}-1.el7.x86_64.rpm && \
    sed -i.ORG -e "s#sysctl -q#sysctl -e -q#" -e "s#^startup#hinemos_check_and_update_listen_address.sh \\&\\& startup#" $HINEMOSHOME/bin/jvm_start.sh && \
    sed -i.ORG "s/export LANG=/#export LANG=/" $HINEMOSWEBHOME/conf/hinemos_web.cfg; \
    yum clean all;

ENV PATH $PATH:$HINEMOSHOME/bin:$PGHOME/bin:$HINEMOSWEBHOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PGHOME/lib

WORKDIR $HINEMOSHOME

USER $PGUSER

EXPOSE 80 8080 8081 8082 514 514/udp 162/udp

#RUN /opt/hinemos/postgresql/bin/pg_ctl start -w -s -l /opt/hinemos/var/log/postgresql.log
#CMD ["postgres"]
# Need to run exactly the same as below otherwise GetPostgreSQLProcessState in jvm_start will fail
CMD ["/opt/hinemos/postgresql/bin/postgres", "-D", "/opt/hinemos/var/data"]


# HOW-TO-USE
#	Built it yourself
# 	$ docker build -t hinemos .
# 	$ docker run -d -p 8000:80 hinemos
#
#	Or pull it from Docker Hub
#	$ docker pull pango853/hinemos
#
#	Tips: Better name your container
# 	$ docker run -d --name myhinemos -p 8000:80 hinemos
#
#	Run it!
# 	$ docker exec --user root myhinemos jvm_start.sh
# 	$ docker exec --user root myhinemos tomcat_start.sh -q
#
#	Now you can http://[HOST IP]:8000/ or http://[CONTAINER PRIVATE IP]:80/
#	And don't forget to set Manager URL as http://[CONTAINER PRIVATE IP]:8080/HinemosWS/
#
#	Run the following command if you don't know the container IP.
# 	$ docker exec myhinemos ip addr show
#
#	Optional: In case you might want to use systemctl, you can run with --privileged option.
# 	$ docker run --privileged -d --name myhinemos -p 8000:80 hinemos /sbin/init
#
#	Optional: Change Web Client language
#	$ docker exec -u root myhinemos localedef -f UTF-8 -i ja_JP /usr/lib/locale/ja_JP.UTF-8
# 	$ docker run -d --name myhinemos -p 8000:80 -e LANG=ja_JP.UTF-8 hinemos
# 	$ docker exec -u root -e LANG=ja_JP.UTF-8 myhinemos tomcat_start.sh -q
#
#	Change listen IP manually
# 	$ docker exec --user root myhinemos jvm_stop.sh
# 	$ docker exec --user root myhinemos /opt/hinemos/sbin/mng/hinemos_change_listen_address.sh -w hinemos SPECIFY_LISTEN_IP
# 	$ docker exec --user root -e AUTOIPFIX=off myhinemos jvm_start.sh
# 	$ docker exec myhinemos netstat -nat
#
#	Misc:
# 	$ docker exec -it myhinemos bash
# 	$ docker exec -it myhinemos psql
# 	$ docker exec myhinemos tail -f /opt/hinemos/var/log/hinemos_manager.log
# 	$ docker exec myhinemos tail -f /opt/hinemos_web/var/log/webclient.log
#
