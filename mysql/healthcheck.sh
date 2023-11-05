#! /bin/bash

export MYSQL_PWD=$(cat /run/secrets/mysql_password) && mysqladmin ping -u $(cat /run/secrets/mysql_user) --silent
