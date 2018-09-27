FROM prismagraphql/prisma:1.16

RUN apk --no-cache add yarn curl
RUN yarn global add prisma graphql-cli --loglevel WARN --production
COPY . /app

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 \
    CMD [ "curl", "-X", "POST", "http://localhost:4466/timeline", "-H", "Content-Type: application/json", "-d", "{\"operationName\":null,\"query\":\"{ __schema { queryType { name } } }\"}" ] || exit 1
