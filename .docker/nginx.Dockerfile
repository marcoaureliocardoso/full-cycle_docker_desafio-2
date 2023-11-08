FROM nginx:1.25-alpine

COPY ./tools/wait-for /usr/local/bin/wait-for
RUN chmod +x /usr/local/bin/wait-for

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD [ "/usr/local/bin/wait-for", "node:3000", "--", "nginx", "-g", "daemon off;" ]
