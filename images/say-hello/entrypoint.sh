#!/bin/bash

file="/home/wiremock/__files/say-hello.json"

if [[ $SAY_HELLO_TO != "" ]]; then
    sed -i -e "s/SAY_HELLO_TO/$SAY_HELLO_TO/g" "$file"
else
    sed -i -e "s/SAY_HELLO_TO//g" "$file"
fi

sleep 5s

set -e

# Set `java` command if needed
if [ "$1" = "" -o "${1:0:1}" = "-" ]; then
  set -- java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner "$@"
fi

# allow the container to be started with `-e uid=`
if [ "$uid" != "" ]; then
  # Change the ownership of /home/wiremock to $uid
  chown -R $uid:$uid /home/wiremock

  set -- gosu $uid:$uid "$@"
fi

exec "$@"