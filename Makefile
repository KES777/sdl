WHOAMI          ?=  ${shell whoami}

export APP_ROOT ?=  ${shell pwd -P}
export CONF_DIR ?=  ${APP_ROOT}/etc
export APP      ?=  ${APP_ROOT}/game.pl

export PATH     :=  ${APP_ROOT}/local/bin:${PATH}

LOCAL_LIBS      :=  ${APP_ROOT}/lib
LOCAL_LIBS      :=  ${LOCAL_LIBS}:${APP_ROOT}/local/lib/perl5
export PERL5LIB :=  ${LOCAL_LIBS}:${PERL5LIB}


DOCKER_CONTAINER :=  postgres-db

DEBUG_CMD = PERLDB_OPTS="white_box" PERL5DB="use DB::Hooks qw'::Terminal ::TraceVariable NonStop'" perl -d


# gen_conf:
# 	cp ${CONF_DIR}/db_env.conf ${CONF_DIR}/db_env.conf.back
# 	${APP} db_env > ${CONF_DIR}/db_env.conf

# $(shell ${APP} db_env > ${CONF_DIR}/db_env.conf)
include ${CONF_DIR}/db_env.conf



# # When staging we still wanna full logs to easily resolve last bugs
# prod:
# 	@MOJO_MODE=staging MOJO_LOG_LEVEL=debug hypnotoad -f ${APP}

# prod-stop:
# 	@kill $$(cat ${APP_ROOT}/run/hypnotoad.pid)

# develop:
# 	@MOJO_MODE=development ${APP} daemon -l http://*:8080


# Put this option if you want docker container allways up with system startup
# --restart='always'

.ONESHELL:
docker-deploy:
# 	mkdir -p ${APP_ROOT}/db/pgdata
# 	docker run --name ${DOCKER_CONTAINER} -d -p ${DB_PORT}:5432      \
# 		--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro     \
# 		-v ${APP_ROOT}/db/pgdata:/var/lib/postgresql/data/pgdata     \
# 		-e PGDATA=/var/lib/postgresql/data/pgdata                    \
# 		-e POSTGRES_PASSWORD=${DB_ROOT}                              \
# 		--restart always                                             \
# 		postgres:10.4
# 	sleep 10
	echo "create user ${DB_CLEAN_USER}                                        \
		with login createdb createrole noinherit password '${DB_CLEAN_PASS}'; \
		CREATE EXTENSION btree_gist;" |                                       \
		docker exec -i ${DOCKER_CONTAINER} psql postgres postgres
# 	${APP} clear_database --yes

# .ONESHELL:
# docker-remove:
# 	docker stop ${DOCKER_CONTAINER}
# 	docker rm ${DOCKER_CONTAINER}
# 	[ -d "${APP_ROOT}/db/pgdata" ]  &&  sudo rm -r ${APP_ROOT}/db/pgdata  ||:

# docker-logs:
# 	docker logs ${DOCKER_CONTAINER}

.ONESHELL:
docker-dbdump:
	file=${APP_ROOT}/db/${DB_NAME}-$$(date "+%Y-%m-%d_%H-%M-%S").sql.gz
	docker exec ${DOCKER_CONTAINER} pg_dump -U postgres ${DB_NAME} \
	  | gzip -f > $${file}
	cp $${file} ${APP_ROOT}/db/${DB_NAME}.sql.gz

docker-dbrestore:
	zcat ${APP_ROOT}/db/${DB_NAME}.sql.gz | \
		docker exec -i ${DOCKER_CONTAINER} psql -U postgres -d ${DB_NAME}

docker-dbshell:
	docker exec -it ${DOCKER_CONTAINER} psql -U postgres -d ${DB_NAME}


dbshell: export PGPASSWORD =  ${DB_PASS}
dbshell:
	psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} ${DB_NAME} ||:

dbdumptable: export PGPASSWORD =  ${DB_PASS}
dbdumptable:
	@echo "COPY( SELECT * FROM \"${TABLE}\" ${WHERE} ) TO STDOUT \
		WITH( FORMAT CSV, HEADER )" |\
		psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} ${DB_NAME}  \
		| gzip -f \
		> ${APP_ROOT}/db/${TABLE}.dump.sql.gz  ||:

dbrestoretable: export PGPASSWORD =  ${DB_PASS}
dbrestoretable:
	line=$$(zcat ${APP_ROOT}/db/${TABLE}.dump.sql.gz | head -n 1); \
	zcat ${APP_ROOT}/db/${TABLE}.dump.sql.gz | \
		psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} ${DB_NAME} -c \
			"BEGIN;COPY \"${TABLE}\"($$line) FROM STDIN WITH( FORMAT CSV, HEADER );COMMIT;"  ||:

dbsql: export PGPASSWORD =  ${DB_PASS}
dbsql:
	cat ${FILE} | \
		psql -h	${DB_HOST} -p ${DB_PORT} -U ${DB_USER} ${DB_NAME}


debug:
	${DEBUG_CMD} ${APP}

test:
	# MOJO_MODE=testing prove t/OpenAPI3/*.t t/MaitreD/*.t
	echo "OK"


APP_NAMESPACE=Schema

export DBIC_MIGRATION_DSN      =  ${DB_DSN}
export DBIC_MIGRATION_USERNAME =  ${DB_USER}
export DBIC_MIGRATION_PASSWORD =  ${DB_PASS}


MIGRATION_CMD :=  $$(which dbic-migration)
ifdef DEBUG
	MIGRATION_CMD :=  ${DEBUG_CMD} ${MIGRATION_CMD}
endif

dbstatus:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib status

dbprepare:
	@echo "WARNING!!! Do not forget to copy deploy migration: 001-a_domains.sql\n"
	${MIGRATION_CMD} --force --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib prepare


dbdeploy:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib install

dbclear:
	${APP} clear_database --yes

dbup:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib upgrade

dbdown:
	# This command downgrades only to one version down.
	# TODO: We should implement last version to rollback to (in case we upgrade by two): -V XX
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib downgrade

# Update underlied database by current schema while developing
dbrefresh: dbdown dbprepare dbup
	@echo "Done!"

dbextract:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib dump_all_sets

dbpopulate:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib populate

dbextractone:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE}  --dbic_fixtures_extra_args debug=1 -Ilib dump_named_sets --fixture_set ${FIXTURE}

dbpopulateone:
	${MIGRATION_CMD} --schema_class ${APP_NAMESPACE} --database ${DB_TYPE} -Ilib populate --fixture_set ${FIXTURE}


# Run this target as: eval `make setenv`
setenv:
	export PATH=${PATH}
	export PERL5LIB=${LOCAL_LIBS}
	export PERL5DB="use DB::Hooks qw'::Terminal ::TraceVariable NonStop'"
	export PERLDB_OPTS="white_box"
	export MOJO_INACTIVITY_TIMEOUT=0

# Hint: How to debug DBIC
# DBIC_TRACE_PROFILE=console DBIC_TRACE=1 <cmd>
