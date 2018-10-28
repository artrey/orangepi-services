docker run -d \
	--name=transmission \
	--restart=always \
	--cpus=".5" -m 512m \
	-v $PWD/config:/config \
	-v $PWD/downloads:/downloads \
	-v $PWD/torrents:/watch \
	-p 9091:9091 \
	-p 51413:51413 \
	-p 51413:51413/udp \
	-e PUID=1000 -e PGID=1000 \
	-e TZ=Europe/Moscow \
	lsioarmhf/transmission-aarch64
