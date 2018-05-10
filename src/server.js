var opentracing = require('opentracing');
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
    'type': 'const',
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
    res.send('Called /');
    console.log('done');
});

app.get('/home', (req, res) => {
    res.send('Called /home');
    if (req.span) {
      req.span.addTags({ 'req': 'is_req' });
      const childSpan = a_tracer.startSpan('child-test', { childOf: req.span })
      childSpan.finish();
    }
    console.log('done');
});

app.get('/child', (req, res) => {
    res.send('Called /child');
    // console.log(parentSpanContext);
    if (req.span) { // Is always here because we use automatic instrumentation
      // console.log(req.span.context());
      const childSpan = a_tracer.startSpan('child-test', { childOf: req.span.context() }); // this is correct only if called with jaeger
      childSpan.addTags({ aCall: 1 });
      childSpan.finish();
    }
    console.log('done');
});

app.get('/child2', (req, res) => {
    res.send('Called /child2');
    // console.log(typeof req.span.context());
    second_tracer = initTracer(config, options);
    const childSpan = second_tracer.startSpan('child-2-test', { childOf: req.span.context() }); // this is correct only if called with jaeger
    childSpan.addTags({ aCall: 1 });
    childSpan.finish();
    console.log('done');
});

// This works only if you call it from outside
app.get('/error', (req, res) => {
    res.send('Called /error');
    // console.log(parentSpanContext);
    if (req.span) {
      // console.log(req.span);
      second_tracer = initTracer(config, options);
      const childSpan = second_tracer.startSpan('child-2-test', { childOf: req.span.context() });
      // const childSpan = a_tracer.startSpan('child-test', { childOf: req.span });
      // CODE HERE
      childSpan.setTag(opentracing.Tags.ERROR, true)
      // childSpan.addTags("test", false)
      // let payload = { a: 1 };
      // childSpan.log({ payload }); # Doesn't work in any combination
      // console.log(childSpan);
      childSpan.finish()
    }
    console.log('done');
});

const server = app.listen(8000, () => {
    // var host = server.address().address;
    var port = server.address().port;
    console.log('Service listening at http://localhost:%s', port);
});
