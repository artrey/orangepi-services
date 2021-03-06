#!/usr/bin/env bash

SERVICE_NAME="fan manager"

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

echo "Checking for file config.yml exists"
CONFIG_FILE="$ROOT_DIR/config.yml"
if [ ! -f "$CONFIG_FILE" ]; then
	echo "File config.yml not found in script folder. Creating empty file..."
  touch "$CONFIG_FILE"
	chcek_return_code_of_last_command $?
	echo "File created: $CONFIG_FILE"
fi

extract_env_variable LOGS_DIR "$ROOT_DIR/logs"
safe_create_folder "$LOGS_DIR" LOGS_DIR

echo "Run container with service '$SERVICE_NAME'"

# payload
docker run -d \
	--name=fan-manager \
	--restart=always \
	--cpus=".05" -m 32m \
	--privileged \
	-v /sys/class/gpio:/sys/class/gpio \
	-v /sys/devices/virtual/thermal/thermal_zone0/temp:/sys/devices/virtual/thermal/thermal_zone0/temp:ro \
	-v "$CONFIG_FILE":/opt/app/config.yml:ro \
	-v "$LOGS_DIR":/opt/app/logs \
	artrey/gpio-fan-manager-arm64


chcek_return_code_of_last_command $?

echo "Service '$SERVICE_NAME' is running"
