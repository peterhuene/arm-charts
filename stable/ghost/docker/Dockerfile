FROM easypi/alpine-arm:3.6
LABEL maintainer "Peter Huene <peter@segfault.guru>"

ENV GHOST_CLI_SOURCE /usr/src/ghost-cli
ENV GHOST_SOURCE /usr/src/ghost
WORKDIR $GHOST_SOURCE

# Use a commit that includes --start option for `ghost setup`
ENV GHOST_VERSION 1.0.0-beta.1
ENV GHOST_ENVIRONMENT development
ENV GHOST_URL http://localhost:2368
ENV GHOST_PORT 2368
ENV GHOST_DATABASE_TYPE sqlite3
ENV GHOST_CONTENT /var/lib/ghost

RUN set -ex; \
    addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node && \
    apk add --no-cache su-exec bash nodejs nodejs-npm tar tini && \
    apk add --no-cache --virtual .build-deps openssl unzip make python g++ git && \
    USER=root HOME=/tmp npm install -g ghost-cli && \   
    ghost install -N --no-stack && \
    apk del .build-deps && \
    rm -rf $GHOST_CLI_SOURCE/.git && \
    npm cache clean && \
    rm -rf /tmp/npm* && \
    mkdir -p "$GHOST_CONTENT" && \
    chown -R node:node "$GHOST_CONTENT" && \
    mv content/ content.orig/ && \
    ln -s "$GHOST_CONTENT" content && \
    ln -s "$GHOST_CONTENT/config.production.json" "$GHOST_SOURCE/config.production.json" && \
    ln -s "$GHOST_CONTENT/config.development.json" "$GHOST_SOURCE/config.development.json"

VOLUME $GHOST_CONTENT

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["tini", "--", "docker-entrypoint.sh"]

EXPOSE 2368
CMD ["ghost", "start"]
