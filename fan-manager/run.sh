docker run -d \
	--name=fan-manager \
	--restart=always \
	--privileged \
	-v /sys/class/gpio:/sys/class/gpio \
	-v /sys/devices/virtual/thermal/thermal_zone0/temp:/sys/devices/virtual/thermal/thermal_zone0/temp:ro \
	-v $PWD/config.yml:/opt/app/config.yml:ro \
	-v $PWD/logs:/opt/app/logs \
	artrey/gpio-fan-manager-arm64
