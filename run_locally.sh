#!/bin/sh

docker network create nodejs_tracing

docker stop jaeger
docker stop tracing-nodejs

docker run --rm -d --net nodejs_tracing --name jaeger \
-e \
  COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest

docker run --rm -d --net nodejs_tracing --name tracing-nodejs -p 8000:8000 jecnua/tracing-nodejs:dev-latest
