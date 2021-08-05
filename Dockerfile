FROM phusion/baseimage:master-amd64
    MAINTAINER Starovoytov Alexandr <saniy200311@gmail.com>

RUN install_clean poppler-utils wget
RUN ln -s /app/bmstu-daemon.sh /bin/bmstu-daemon && \
    ln -s /app/bmstu-iu9.sh /bin/bmstu-iu9
WORKDIR /app
COPY ./bmstu-daemon.sh ./bmstu-iu9.sh ./
CMD ./bmstu-daemon
