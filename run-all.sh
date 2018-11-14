#!/usr/bin/env bash

echo "Detecting root dir of script..."
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
echo "Script folder: $ROOT_DIR"

echo "Running services..."
bash "$ROOT_DIR/fan-manager/run.sh"
bash "$ROOT_DIR/samba/run.sh"
bash "$ROOT_DIR/transmission/run.sh"
bash "$ROOT_DIR/plex/run.sh"
