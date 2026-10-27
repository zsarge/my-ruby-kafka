#!/bin/sh
set -eu

exec ruby "$(dirname "$0")/bin/server" "$@"
