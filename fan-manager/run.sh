#!/usr/bin/env bash

echo "Looking for root dir of fan manager run script"
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"
echo "Script located in $PWD"

echo "Checking for file config.yml exists"
if [ ! -f "config.yml" ]; then
  touch "config.yml"
fi

echo "Creating logs folder if not exists"
if [ ! -d "logs" ]; then
  mkdir "logs"
fi

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
