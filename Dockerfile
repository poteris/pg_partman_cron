FROM postgres:16

ENV PG_PARTMAN_VERSION v5.2.4
ENV PG_CRON_VERSION v1.6.7

RUN apt-get update && apt-get install wget build-essential tar postgresql-16-partman postgresql-16-cron -y

RUN echo "shared_preload_libraries='pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample

# Change permissions of the postgresql.conf.sample file
RUN chown postgres:postgres /usr/share/postgresql/postgresql.conf.sample && \
    chmod 664 /usr/share/postgresql/postgresql.conf.sample

COPY ./entrypoint.sh /usr/local/bin/custom-entrypoint.sh
COPY ./initdb/setup-users.sql /docker-entrypoint-initdb.d/

RUN chmod +x /usr/local/bin/custom-entrypoint.sh

USER postgres
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["postgres"]
