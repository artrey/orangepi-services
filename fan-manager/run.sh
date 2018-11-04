#!/usr/bin/env bash

# find root dir of script
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"

echo "Run fan-manager container"

# payload
docker run -d \
	--name=fan-manager \
	--restart=always \
	--privileged \
	-v /sys/class/gpio:/sys/class/gpio \
	-v /sys/devices/virtual/thermal/thermal_zone0/temp:/sys/devices/virtual/thermal/thermal_zone0/temp:ro \
	-v $PWD/config.yml:/opt/app/config.yml:ro \
	-v $PWD/logs:/opt/app/logs \
	artrey/gpio-fan-manager-arm64

ret=$?
if [ $ret -ne 0 ]; then
    echo "Fan manager is not running"
		exit $ret
fi

echo "Fan manager is running"
