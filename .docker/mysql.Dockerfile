FROM mysql:8.2

COPY ./mysql/mysql_root_password /run/secrets/mysql_root_password
COPY ./mysql/mysql_user /run/secrets/mysql_user
COPY ./mysql/mysql_password /run/secrets/mysql_password

COPY ./mysql/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

EXPOSE 3306
