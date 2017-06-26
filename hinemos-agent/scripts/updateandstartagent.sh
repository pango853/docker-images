#!/bin/bash -e

if [ $# -lt 1 ]; then

# Update manager IP
if [ ! "x${MANAGER_IP_ADDRESS}" = "x" ]; then
	sed -i.BAK "s#^\\(managerAddress=http.\\?://\\)\\([^:/]\\+\\)#\1$MANAGER_IP_ADDRESS#" $HINEMOSAGTHOME/conf/Agent.properties
fi

# Start Agent
$HINEMOSAGTHOME/bin/start.sh

else
# Just run other argument if not hinemos_agent
exec "$@"
fi

