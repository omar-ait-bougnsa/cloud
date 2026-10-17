FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
    && mkdir -p /var/lib/mysql

COPY conf/server.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setupdb.sh /usr/local/bin/setupdb.sh 

RUN chmod +x /usr/local/bin/setupdb.sh && \
    chown mysql:mysql /usr/local/bin/setupdb.sh

ENTRYPOINT ["/usr/local/bin/setupdb.sh"]