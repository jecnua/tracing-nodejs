#!/bin/sh

docker network create nodejs_tracing

docker stop jaeger
docker stop tracing-nodejs
docker stop prometheus
docker stop grafana

# Port to call 16686
docker run \
  --rm \
  -d \
  --net nodejs_tracing \
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
  jaegertracing/all-in-one:1.5.0

docker run \
  --rm \
  -d \
  --net nodejs_tracing \
  --name tracing-nodejs \
  -p 8000:8000 \
  jecnua/tracing-nodejs:dev-latest

docker stop prometheus
docker run --rm -d -p 9090:9090 \
    --name=prometheus \
    --net nodejs_tracing \
    -v "$(pwd)"/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus:v2.2.1

docker stop grafana
docker run -d --rm --name=grafana --net nodejs_tracing \
  -e 'GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel' \
  -e 'GF_AUTH_ANONYMOUS_ENABLED=true' \
  -e 'GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer' \
  -e 'GF_SECURITY_ADMIN_PASSWORD=admin' \
  -e 'GF_ANALYTICS_REPORTING_ENABLED=false' \
  -v "$PWD"/providers.yml:/etc/grafana/provisioning/dashboards/providers.yaml:ro \
  -v "$PWD"/jaeger.json:/var/lib/grafana/dashboards/jaeger.json:ro \
  -v "$PWD"/prom.yaml:/etc/grafana/provisioning/datasources/datasource.yaml:ro \
  -p 3000:3000 \
  grafana/grafana:5.1.2

# docker run \
#   --rm \
#   -it \
#   --net nodejs_tracing \
#   -v "$(pwd)"/src:/src/ \
#   --name tracing-nodejs \
#   -p 8000:8000 \
#   jecnua/tracing-nodejs:dev-latest


# sleep 10

curl localhost:8000/
curl localhost:8000/home
curl localhost:8000/child
curl localhost:8000/child2
curl localhost:8000/error
