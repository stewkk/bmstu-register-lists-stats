FROM phusion/baseimage:master-amd64
    MAINTAINER Starovoytov Alexandr <saniy200311@gmail.com>

RUN install_clean poppler-utils wget
WORKDIR /app
COPY ./bmstu-daemon.sh ./bmstu-iu9.sh ./
CMD ./bmstu-iu9.sh
