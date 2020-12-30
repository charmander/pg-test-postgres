#!/bin/sh
set -eu

cat >|"$PGDATA/pg_hba.conf" <<-'END'
	local all all trust

	host all postgres all trust
	host all postgres_password all password
END

psql -v ON_ERROR_STOP=1 <<-'SQL'
	CREATE ROLE postgres_password SUPERUSER LOGIN PASSWORD 'test-password';

	DO $$
		DECLARE
			version integer;
		BEGIN
			SHOW server_version_num INTO version;

			IF version >= 100000 THEN
				SET password_encryption = 'scram-sha-256';
				CREATE ROLE scram_test LOGIN PASSWORD 'test4scram';
				CREATE EXTENSION IF NOT EXISTS adminpack;
				PERFORM pg_file_write('pg_hba.conf', E'host all scram_test all scram-sha-256\n', true);
			END IF;
		END
	$$;
SQL
