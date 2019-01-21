# Tracing with Jaeger in nodejs express

[![Build Status](https://travis-ci.org/jecnua/tracing-nodejs.svg?branch=master)](https://travis-ci.org/jecnua/tracing-nodejs)
[![](https://images.microbadger.com/badges/image/jecnua/tracing-nodejs.svg)](https://microbadger.com/images/jecnua/tracing-nodejs "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/jecnua/tracing-nodejs.svg)](https://microbadger.com/images/jecnua/tracing-nodejs "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/jecnua/tracing-nodejs.svg)](https://microbadger.com/images/jecnua/tracing-nodejs "Get your own commit badge on microbadger.com")
[![](https://images.microbadger.com/badges/license/jecnua/tracing-nodejs.svg)](https://microbadger.com/images/jecnua/tracing-nodejs "Get your own license badge on microbadger.com")

![status](https://img.shields.io/badge/project_status-active-green.svg)
![ubuntu-1604](https://img.shields.io/badge/ubuntu-18.04-green.svg)
![node.js](https://img.shields.io/badge/node.js-v8.10.0-green.svg)
![framework](https://img.shields.io/badge/express-v4.16.3-green.svg)

This repo contains a simple test of jaeger tracing with a nodejs express
application.

## Personal notes

- [jaeger notes](https://go-talks.appspot.com/github.com/jecnua/notes-presentations/notes/observability/tracing/03-jaeger.article)

## Scope

I am trying to test Jaeger tracing with node.js automatic instrumentation of the express framework. I successfully attached the tracing to express and calls to paths are traced correctly.

The next step will be to try and see how to create span and attach them to existing traces coming from other services.

## Demo

Run:

    make
    ./run_locally.sh

Check traces at: http://localhost:16686/

## Test

To run dgoss test locally:

    make
    ./test_locally.sh

## Resources

- [http://label-schema.org/rc1/](http://label-schema.org/rc1/)
- https://www.npmjs.com/package/jaeger-client
- https://github.com/jaegertracing/jaeger-client-node
- https://github.com/opentracing-contrib/javascript-express
- https://github.com/jaegertracing/jaeger-client-python

## Knowns issue

<trace-without-root-span> when calling all url togheter.

## TODO

- Add monitoring with grafana and prometheus
- Run in in k8s
