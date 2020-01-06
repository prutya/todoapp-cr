FROM alpine:3.11.2 as build

RUN apk add --update --no-cache --no-progress \
  crystal=0.31.1-r2 \
  shards=0.9.0-r1 \
  alpine-sdk=1.0-r0 \
  yaml-dev=0.2.2-r1 \
  zlib-dev=1.2.11-r3 \
  zlib-static=1.2.11-r3 \
  libressl-dev=3.0.2-r0 \
  libressl3.0-libcrypto=3.0.2-r0 \
  libevent-static=2.1.11-r0

WORKDIR /usr/src/app

COPY shard.yml shard.lock ./

RUN shards install --production

COPY . .

RUN mkdir -p ./bin \
  && crystal build --release --static ./src/app.cr -o ./bin/app



FROM scratch

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/bin/app ./bin/app

ENTRYPOINT ["./bin/app"]
