FROM ubuntu:18.04

RUN mkdir -p /src

COPY package.json package.json
COPY /src/* /src/
COPY Dockerfile /Dockerfile

RUN apt-get update \
  && apt-get install --no-install-recommends -y npm=3.5.2-0ubuntu4 \
    nodejs=8.10.0~dfsg-2ubuntu0.4 curl=7.58.0-2ubuntu3.6 wget=1.19.4-1ubuntu2.1 \
    nano=2.9.3-2 build-essential=12.4ubuntu1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && npm config set strict-ssl false \
  && npm install

# ENV

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

# Metadata
LABEL maintainer="fabrizio.sabatini.it@gmail.com"
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="tracing-nodejs" \
  org.label-schema.description="A nodejs tracing test with jaeger" \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/jecnua/tracing-nodejs" \
  org.label-schema.schema-version="1.0" \
  com.jecnua.docker.dockerfile="/Dockerfile" \
  com.jecnua.license="MIT"

CMD ["npm", "start"]
