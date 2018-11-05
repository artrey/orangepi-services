#!/usr/bin/env bash

# find root dir of script
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"

echo "Run transmission container"

# payload
docker run -d \
	--name=transmission \
	--restart=always \
	--cpus=".5" -m 512m \
	-v $PWD/config:/config \
	-v $PWD/../media:/downloads/complete \
	-v $PWD/torrents:/watch \
	-p 9091:9091 \
	-p 51413:51413 \
	-p 51413:51413/udp \
	-e PUID=1000 -e PGID=1000 \
	-e TZ=Europe/Moscow \
	lsioarmhf/transmission-aarch64

ret=$?
if [ $ret -ne 0 ]; then
	echo "Transmission is not running"
	exit $ret
fi

echo "Transmission is running"
