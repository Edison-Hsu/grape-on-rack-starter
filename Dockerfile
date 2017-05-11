FROM edisonhsu/ruby:2.4-onbuild-china-source

LABEL maintainer "edison.hsu.sh@gmail.com"

COPY ./config/database_docker.yml /usr/src/app/db/config.yml
RUN chmod +x ./boot.sh

EXPOSE 8088

ENTRYPOINT ./boot.sh
