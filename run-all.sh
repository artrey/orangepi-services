#!/usr/bin/env bash

# find root dir of script
ROOT_DIR="$( cd "$( dirname "$0" )" >/dev/null && pwd )"
cd "$ROOT_DIR"

# creating media folder for all media files (such as movies, serials, music, etc.)
if [ ! -d "media" ]; then
  mkdir "media"
fi

exec sh fan-manager/run.sh
exec sh samba/run.sh
exec sh transmission/run.sh
exec sh plex/run.sh
