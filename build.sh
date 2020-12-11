#!/bin/sh
set -eu

if test $# -ne 1; then
	echo >&2 'usage: build.sh <tag>'
fi

tag="$1"

podman build -t ghcr.io/charmander/pg-test-postgres:"$tag" -f "$tag" .
