#!/bin/sh
# There is no need to rm them since they are run with --rm

docker stop jaeger
docker stop tracing-nodejs
docker stop prometheus
docker stop grafana
