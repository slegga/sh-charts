use Mojolicious::Lite;
use Data::Dumper;
my $datfile = "/tmp/values.txt";

# Answer to /
get '/' => sub {
    my $c = shift;
    {
        $Data::Dumper::Terse = 1;        # don't output names where feasible
        $Data::Dumper::Indent = 0;       # turn off all pretty print
        my $mydata= Dumper [[1000,23],[2222,45],[3333,30],[4444,55]];
        $c->stash(mydata=>$mydata);
    }
    $c->render(template => 'live', format => 'html');
};


app->start;


__DATA__

@@ live.html.ep
<head>
  <meta charset="utf-8">
  <title>Test</title>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/data.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const chart = Highcharts.chart('container', {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: 'USD to EUR exchange rate over time'
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
            },
            xAxis: {
                type: 'datetime'
            },
            yAxis: {
                title: {
                    text: 'Exchange rate'
                }
            },
            legend: {
                enabled: false
            },
            plotOptions: {
                area: {
                    fillColor: {
                        linearGradient: {
                            x1: 0,
                            y1: 0,
                            x2: 0,
                            y2: 1
                        },
                        stops: [
                            [0, Highcharts.getOptions().colors[0]],
                            [1, Highcharts.color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                        ]
                    },
                    marker: {
                        radius: 2
                    },
                    lineWidth: 1,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    },
                    threshold: null
                }
            },

            series: [{
                type: 'area',
                name: 'USD to EUR',
                data: <%= stash('mydata') %>
            }]
        });
    }
);
</script>
</head>
<body>
<div id="container" style="width:100%; height:400px;"></div>
</body>
</html>
