#!/bin/sh
set -eu

cat >>"$PGDATA/postgresql.conf" <<-'END'
	ssl = on
	ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
	ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'
END
