FROM easypi/alpine-arm:3.6
LABEL maintainer "Peter Huene <peter@segfault.guru>"

RUN set -xe \
    # Install packages
    && apk add --no-cache su-exec bash tini mariadb mariadb-client tzdata \
    # Remove explicit user setting
    && sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf \
    # Create the data and run directories
    && rm -rf /var/lib/mysql \
    && mkdir -p /var/lib/mysql /run/mysqld \
    # Set owners to the default user
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld \
    # Make the run directory world writable to support running as a different user
    && chmod 777 /run/mysqld \
    && sed -Ei -e 's/^(bind-address|log)/#&/' \
               -e 's/^\[mysqld\]$/&\nskip-host-cache\nskip-name-resolve/' \
               /etc/mysql/my.cnf

COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/mysql
ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
