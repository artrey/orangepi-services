#!/usr/bin/env bash

# find root dir of script
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"

echo "Run plex container"

# payload
docker run -d \
	--name=plex \
	--restart=always \
	--net=host \
	-v $PWD/config:/config \
	-v $PWD/../media:/data \
	-v $PWD/transcode:/transcode \
	-e PUID=1000 -e PGID=1000 \
	lsioarmhf/plex

ret=$?
if [ $ret -ne 0 ]; then
	echo "Plex is not running"
	exit $ret
fi

echo "Plex is running"
