#!/bin/sh
cp /usr/local/newrelic/* /newrelic/

while :
do
    sleep 5
	echo "Im alive! "$(date)
done
