docker run -d \
	--name=plex \
	--restart=always \
	--net=host \
	-v $PWD/config:/config \
	-v $PWD/data/movies:/data/movies \
	-v $PWD/data/serials:/data/serials \
	-v $PWD/transcode:/transcode \
	-e PUID=1000 -e PGID=1000 \
	lsioarmhf/plex
