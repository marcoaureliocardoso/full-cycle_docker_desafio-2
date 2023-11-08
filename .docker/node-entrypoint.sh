#! /bin/sh

cd /app
npm install
/usr/local/bin/wait-for mysql:3306 -- docker-entrypoint.sh npm start
