const opentracing = require('opentracing');
const middleware = require('express-opentracing').default
const express = require('express');

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
    'test-nodejs-jaeger-tracing': '0.3.0'
  }
};

var initTracer = require('jaeger-client').initTracer;
var a_tracer = initTracer(config, options);
const app = express();
app.use(middleware({tracer: a_tracer}));

app.get('/', (req, res) => {
    res.send('Hello world');
});

app.get('/home', (req, res) => {
    res.send('Welcome home');
});

app.get('/about', (req, res) => {
    const childSpan = a_tracer.startSpan('child-test', { childOf: req.span });
    childSpan.addTags({ aCall: 1 });
    // test()
    childSpan.finish();
    res.send('This is me');
});

const server = app.listen(8000, () => {
    var host = server.address().address;
    var port = server.address().port;
    console.log('Service listening at http://localhost:%s', host, port);
});
