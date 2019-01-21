#!/usr/bin/env bash

docker rm -f tracing-nodejs

docker run \
  --rm \
  -d \
  --net host \
  -v "$(pwd)"/src:/src/ \
  --name tracing-nodejs \
  -p 8000:8000 \
  jecnua/tracing-nodejs:dev-latest

echo "Sleeping 5 seconds"
sleep 5

curl localhost:8000/
sleep 1
curl localhost:8000/home
curl localhost:8000/child
curl localhost:8000/child2
curl localhost:8000/error
