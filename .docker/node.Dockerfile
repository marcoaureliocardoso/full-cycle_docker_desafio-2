FROM node:20.9-alpine

COPY ./tools/wait-for /usr/local/bin/wait-for
RUN chmod +x /usr/local/bin/wait-for

COPY ./.docker/node-entrypoint.sh /usr/local/bin/node-entrypoint.sh
RUN chmod +x /usr/local/bin/node-entrypoint.sh

RUN mkdir -p /run/secrets
COPY ./mysql/mysql_user /run/secrets/mysql_user
COPY ./mysql/mysql_password /run/secrets/mysql_password
RUN chmod +r /run/secrets/mysql_user && \
    chmod +r /run/secrets/mysql_password

WORKDIR /app

EXPOSE 3000

ENTRYPOINT [ "/usr/local/bin/node-entrypoint.sh" ]
