#!/bin/sh
set -eu

cat >|"$PGDATA/pg_hba.conf" <<-'END'
	local all all trust

	host all postgres all trust
	host all postgres_password all password
	host all scram_test all scram-sha-256
END

psql -v ON_ERROR_STOP=1 <<-'END'
	CREATE ROLE postgres_password SUPERUSER LOGIN PASSWORD 'test-password';
	SET password_encryption = 'scram-sha-256';
	CREATE ROLE scram_test LOGIN PASSWORD 'test4scram';
END
