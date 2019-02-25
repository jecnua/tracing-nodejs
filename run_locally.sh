#!/bin/sh

JAEGER_VERSION='1.10.1'
PROMETHEUS_VERSION='v2.7.1'

# docker network create host

docker rm -f jaeger
docker rm -f tracing-nodejs
docker rm -f prometheus
docker rm -f grafana

# Port to call 16686
docker run \
  --rm \
  -d \
  --net host \
  --name jaeger \
  -e \
  COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 9411:9411 \
  "jaegertracing/all-in-one:$JAEGER_VERSION"

docker rm -f prometheus
docker run \
    --rm \
    -d \
    -p 9090:9090 \
    --name=prometheus \
    --net host \
    -v "$(pwd)"/prometheus.yml:/etc/prometheus/prometheus.yml \
    "prom/prometheus:$PROMETHEUS_VERSION"

# docker rm -f grafana
# docker run -d --rm --name=grafana --net host \
#   -e 'GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel' \
#   -e 'GF_AUTH_ANONYMOUS_ENABLJAEGER_VERSIONED=true' \
#   -e 'GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer' \
#   -e 'GF_SECURITY_ADMIN_PASSWORD=admin' \
#   -e 'GF_ANALYTICS_REPORTING_ENABLED=false' \
#   -v "$PWD"/providers.yml:/etc/grafana/provisioning/dashboards/providers.yaml:ro \
#   -v "$PWD"/jaeger.json:/var/lib/grafana/dashboards/jaeger.json:ro \
#   -v "$PWD"/prom.yaml:/etc/grafana/provisioning/datasources/datasource.yaml:ro \
#   -p 3000:3000 \
#   grafana/grafana:5.4.3

sleep 5

docker run \
  --rm \
  -d \
  --net host \
  -v "$(pwd)"/src:/src/ \
  --name tracing-nodejs \
  -p 8000:8000 \
  jecnua/tracing-nodejs:dev-latest

sleep 5

curl localhost:8000/
curl localhost:8000/home
curl localhost:8000/child
curl localhost:8000/child2
curl localhost:8000/error
