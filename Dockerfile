FROM alpine
    MAINTAINER Starovoytov Alexandr <saniy200311@gmail.com>

RUN apk add --no-cache bash poppler-utils
WORKDIR /app
COPY ./bmstu-daemon.sh ./bmstu-iu9.sh ./
CMD ./bmstu-iu9.sh
