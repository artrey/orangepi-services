#!/usr/bin/env bash

SERVICE_NAME="plex"

chcek_return_code_of_last_command() {
	if [[ $1 != 0 ]]; then
		echo "Service '$SERVICE_NAME' is not running"
		exit $1
	fi
}

extract_env_variable() {
	# Checking the env variable and set it to default value if not exists
	# $1 env variable name
	# $2 default value for this variable
	echo "Detecting env variable $1..."
	eval temp=\$$1
	if [ -z "$temp" ]; then
		echo "Detected empty value... Setting to default: $2"
		temp="$2"
	fi
	echo "$1=$temp"
	eval $1=\"$temp\"
}

safe_create_folder() {
	# Creating folder if not exists and set abs path to specify variable
	# $1 path to folder (absolute or relative)
	# $2 name of variable for returning abs path
	if [ ! -d "$1" ]; then
		echo "Creating folder..."
		mkdir -p "$1"
		chcek_return_code_of_last_command $?
	fi

	abs_path="$( cd "$1" >/dev/null && pwd )"
	eval $2=\"$abs_path\"
}

echo "Detecting root dir of script..."
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
echo "Script folder: $ROOT_DIR"

echo "Preparing environment for service '$SERVICE_NAME'"

extract_env_variable MEDIA_DIR "$ROOT_DIR/media"
safe_create_folder "$MEDIA_DIR" MEDIA_DIR

extract_env_variable CONFIG_DIR "$ROOT_DIR/config"
safe_create_folder "$CONFIG_DIR" CONFIG_DIR

extract_env_variable TRANSCODE_DIR "$ROOT_DIR/transcode"
safe_create_folder "$TRANSCODE_DIR" TRANSCODE_DIR

echo "Run container with service '$SERVICE_NAME'"

# payload
docker run -d \
	--name=plex \
	--restart=always \
	--cpus=".5" -m 512m \
	--net=host \
	-v "$MEDIA_DIR":/data \
	-v "$CONFIG_DIR":/config \
	-v "$TRANSCODE_DIR":/transcode \
	-e PUID=1000 -e PGID=1000 \
	lsioarmhf/plex

chcek_return_code_of_last_command $?

echo "Service '$SERVICE_NAME' is running"
