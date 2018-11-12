FROM alpine:3.4
MAINTAINER technik@myfoodmap.de

ENV APP_NAME        "default"
ENV CRON_INTERVAL   "0 4 * * *"
ENV GPG_RECIPIENT   "mail@ditoy.com"
ENV APP_NAME        "default"
ENV S3_BUCKET_NAME  "default-bucket"
ENV AWS_ACCESS_KEY_ID       "key"
ENV AWS_SECRET_ACCESS_KEY   "secret"
ENV AWS_DEFAULT_REGION      "eu-central-1"

RUN apk add --update \
    py-pip \
    gpgme \
    xz \
    && rm -rf /var/cache/apk/*

RUN pip install awscli

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
