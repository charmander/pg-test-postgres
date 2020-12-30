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
	COPY --chown=postgres:postgres pg-test-ssl /pg-test-ssl
	RUN chmod 0600 /pg-test-ssl/*.key
	COPY password.sh ssl.sh /docker-entrypoint-initdb.d/
END
