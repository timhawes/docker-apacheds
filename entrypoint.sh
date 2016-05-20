#!/bin/bash

if [ "$1" = "bash" ]; then
  exec bash
fi

if [ -e "/opt/apacheds/instances/default/conf" ]; then
  echo "Using existing instance"
else
  echo "Creating default instance"
  cp -R /opt/apacheds/instances/template/* /opt/apacheds/instances/default/
fi

echo "Fixing permissions"
chown -R apacheds:apacheds /opt/apacheds/instances/default

echo "Starting ApacheDS"
runuser -u apacheds /opt/apacheds/bin/apacheds.sh default run
