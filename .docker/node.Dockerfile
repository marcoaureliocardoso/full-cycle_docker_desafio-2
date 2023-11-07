FROM node:20.9-alpine

COPY ./tools/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for

RUN mkdir -p /run/secrets
COPY ./mysql/mysql_user /run/secrets/mysql_user
COPY ./mysql/mysql_password /run/secrets/mysql_password
RUN chmod +r /run/secrets/mysql_user && \
    chmod +r /run/secrets/mysql_password

WORKDIR /app
COPY ./node/index.js /app/index.js
COPY ./node/package.json /app/package.json

RUN npm install

EXPOSE 3000
ENTRYPOINT [ "/usr/bin/wait-for", "mysql:3306", "--", "docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
