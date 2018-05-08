import logging
import time
from jaeger_client import Config
import requests
import sys
import time
from opentracing_instrumentation.request_context import get_current_span, span_in_context
from opentracing.ext import tags
from opentracing.propagation import Format

if __name__ == "__main__":
    log_level = logging.DEBUG
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(asctime)s %(message)s', level=log_level)

    config = Config(
        config={ # usually read from some yaml config
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'local_agent': {
                'reporting_host': 'localhost',
                'reporting_port': 6831,
            },
            'logging': True,
        },
        service_name='test-nodejs-jaeger-tracing',
        validate=True,
    )
    # this call also sets opentracing.tracer
    tracer = config.initialize_tracer()

    with tracer.start_span('TestSpan') as span:
        span.log_kv({'event': 'test message', 'life': 42})

        with tracer.start_span('ChildSpan', child_of=span) as child_span:
            child_span.log_kv({'event': 'down below'})

        port = '8000'
        path = 'about'
        url = 'http://localhost:%s/%s' % (port, path)

        # span = get_current_span()
        span.set_tag(tags.HTTP_METHOD, 'GET')
        span.set_tag(tags.HTTP_URL, url)
        # span.set_tag(tags.SPAN_KIND, tags.SPAN_KIND_RPC_CLIENT)
        headers = {}
        tracer.inject(span, Format.HTTP_HEADERS, headers)

        r = requests.get(url, params='test', headers=headers)
        assert r.status_code == 200
    # return r.text

    time.sleep(2)   # yield to IOLoop to flush the spans - https://github.com/jaegertracing/jaeger-client-python/issues/50
    tracer.close()  # flush any buffered spans
