#!/bin/sh
set -eu

(cd /pg-test-ssl && cp test-server.crt test-server.key test-client-ca.crt "$PGDATA/")

cat >>"$PGDATA/postgresql.conf" <<-'END'
	ssl = on
	ssl_cert_file = 'test-server.crt'
	ssl_key_file = 'test-server.key'
	ssl_ca_file = 'test-client-ca.crt'
END

cat >>"$PGDATA/pg_hba.conf" <<-'END'
	hostssl all all all cert
END
