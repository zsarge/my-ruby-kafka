#!/bin/sh
set -eu

entrypoint="${BROKER_ENTRYPOINT:-bin/server}"
exec ruby "$(dirname "$0")/$entrypoint" "$@"
