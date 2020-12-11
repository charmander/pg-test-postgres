#!/bin/sh
set -eu

if test $# -ne 1; then
	echo >&2 'usage: generate.sh <tag>'
fi

tag="$1"

podman pull docker.io/library/postgres:"$tag"
digest="$(podman image inspect -f '{{.Digest}}' docker.io/library/postgres:"$tag")"
cat >|"$tag" <<-END
	FROM docker.io/library/postgres@$digest
	LABEL org.opencontainers.image.source https://github.com/charmander/pg-test-postgres
	COPY ssl.sh /docker-entrypoint-initdb.d/ssl.sh
END
