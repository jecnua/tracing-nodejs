#!/usr/bin/env bash

docker rm -f jaeger
docker rm -f tracing-nodejs
docker rm -f prometheus
docker rm -f grafana

# docker run \
#   --rm \
#   -d \
#   --net nodejs_tracing \
#   -v "$(pwd)"/src:/src/ \
#   --name tracing-nodejs \
#   -p 8000:8000 \
#   jecnua/tracing-nodejs:dev-latest
