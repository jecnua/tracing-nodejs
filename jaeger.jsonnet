local grafana = import "grafonnet/grafana.libsonnet";
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;

dashboard.new(
    "Jaeger standalone metrics",
    tags=["jaeger","prometheus"],
    time_from='now-15m',
    editable=true,
    refresh='5s',
)
.addRow(
    row.new()
    .addPanel(
      singlestat.new(
          'Total traces',
          format='none',
          description='',
          interval=null,
          height=250,
          datasource='prometheus',
          span=1,
          min_span=null,
          decimals=null,
          valueName='avg',
          valueFontSize='80%',
          prefixFontSize='50%',
          postfixFontSize='50%',
          mappingType=1,
          repeat=null,
          repeatDirection=null,
          prefix='',
          postfix='',
        )
        .addTarget(
            prometheus.target(
                "sum(jaeger_standalone:jaeger:traces{})",
            )
        )
    )
    .addPanel(
      singlestat.new(
          'Spans dropped',
          format='none',
          description='',
          interval=null,
          height=250,
          datasource='prometheus',
          span=1,
          min_span=null,
          decimals=null,
          valueName='avg',
          valueFontSize='80%',
          prefixFontSize='50%',
          postfixFontSize='50%',
          mappingType=1,
          repeat=null,
          repeatDirection=null,
          prefix='',
          postfix='',
        )
        .addTarget(
            prometheus.target(
                "sum(jaeger_standalone:jaeger_collector:spans_dropped{})",
            )
        )
    )
    .addPanel(
      graphPanel.new(
          'started and finished spans',
          span=6,
          format='short',
          fill=1,
          min=0,
          decimals=2,
          datasource='prometheus',
          legend_values=true,
          legend_min=false,
          legend_max=false,
          legend_current=true,
          legend_total=false,
          legend_avg=false,
          legend_alignAsTable=true,
          height=400,
        )
        .addTarget(
            prometheus.target(
                "jaeger_standalone:jaeger:started_spans{}",
            )
        )
        .addTarget(
            prometheus.target(
                "jaeger_standalone:jaeger:finished_spans{}",
            )
        )
        .addTarget(
            prometheus.target(
                "jaeger_standalone:jaeger:finished_spans{}",
            )
        )
    )
    .addPanel(
      graphPanel.new(
          'started - finished',
          span=6,
          format='short',
          fill=0,
          min=0,
          decimals=2,
          datasource='prometheus',
          legend_values=true,
          legend_min=true,
          legend_max=true,
          legend_current=true,
          legend_total=false,
          legend_avg=true,
          legend_alignAsTable=true,
        )
        .addTarget(
            prometheus.target(
                "sum(jaeger_standalone:jaeger:started_spans{}) - sum(jaeger_standalone:jaeger:finished_spans{})",
            )
        )
    )
)
