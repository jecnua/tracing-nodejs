var initTracer = require('jaeger-client').initTracer;

// See schema https://github.com/jaegertracing/jaeger-client-node/blob/master/src/configuration.js#L37
var config = {
  'serviceName': 'test-nodejs-jaeger-tracing',
  'reporter': {
    'logSpans': true,
    'agentHost': 'docker.for.mac.localhost',
    'agentPort': 6832
  },
  'sampler': {
    'type': 'probabilistic',
    'param': 1.0
  }
};
var options = {
  'tags': {
    'test-nodejs-jaeger-tracing': '1.0.0'
  }
  //'metrics': metrics,
  //'logger': logger
};
var tracer = initTracer(config, options);

const express = require('express');
const app = express();

// Handle a GET request on the root path
app.get('/', (req, res) => {
    const parentSpan = tracer.startSpan('http_request');
    res.send('Hello Jaeger');
    parentSpan.log({'event': 'request_end'});
    ////
    const childSpan = tracer.startSpan('child-test', { childOf: parentSpan });
    childSpan.addTags({ aCall: 1 });
    await sleep(getRandomInt(200, 1000));
    childSpan.finish();
    ////
    parentSpan.finish();
});

// Set up server
const server = app.listen(8000, () => {
    var host = server.address().address;
    var port = server.address().port;
    console.log('Service listening at http://localhost:%s', host, port);
});
