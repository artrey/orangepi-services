docker run -d \
	--name=samba \
	--restart=always \
	-v $PWD/share:/data \
	-p 137:137/udp -p 138:138/udp \
	-p 139:139/tcp -p 445:445/tcp \
	-e USER_NAME=samba -e USER_PASSWD=mediasamba \
	-e SAMBA_SHARE="public=/data" \
	forumi0721alpineaarch64/alpine-aarch64-samba
