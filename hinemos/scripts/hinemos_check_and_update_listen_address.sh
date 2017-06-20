#!/bin/bash

if [ ! "x${AUTOIPFIX}" = "x1" ]
then
	exit 0
fi


########################################
#  Hinemos Settings
########################################
DBNAME=hinemos

########################################
# Function
########################################

function usage() {
	echo "Usage : ${PROG} [-w passwd] [IP_ADDERSS]"
	echo "Options:"
	echo "  -w passwd  set password for Hinemos RDBM Server"
}

########################################
# MAIN
########################################
for OPT in $@
do
	case $OPT in
		--help|-h)
			usage
			exit 0
			;;
	esac
done

# option check
while getopts w: OPT
do
	case $OPT in
		w)
			export PGPASSWORD=${OPTARG}
			;;
		*)
			echo "[ERROR] What are you doing?!"
			exit 1
			;;
	esac
done

shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]
then
	IPADDRESS=`hostname -i`
else
	IPADDRESS=$1
fi


if [ ! "x${PGPASSWORD}" = "x" ]
then
	export PGPASSWORD
fi

. ${HINEMOSHOME}/hinemos.cfg

SQL="SELECT COUNT(*) FROM setting.cc_hinemos_property WHERE property_key LIKE 'ws.client.address' AND value_string LIKE 'http%://${IPADDRESS}:%';"
CNT=`${PG_HOME}/bin/psql -p 24001 -U ${PG_USER} -d ${DBNAME} -qtA -c "${SQL}"`
RET=$?
if [ $RET -eq 0 -a "x$CNT" = "x0" ]
then
	echo "Update listen address to $IPADDRESS..."
	${HINEMOSHOME}/bin/jvm_stop.sh
	${HINEMOSHOME}/sbin/mng/hinemos_change_listen_address.sh $IPADDRESS
fi

exit 0
