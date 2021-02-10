use Mojolicious::Lite;

my $datfile = "/tmp/values.txt";

# Answer to /
get '/' => sub {
    my $c = shift;
    $c->render(template => 'live', format => 'html');
};

# Set value from GET call
get '/setvalue/:value' => sub { 
    my $c   = shift;
    my $value = $c->param('value');
    open(my $fh, '>', $datfile) or die "Could not open $datfile $!";
    print $fh "$value\n";
    close $fh;
    $c->render(text => "You set the value to $value");
};

# Get value from GET call
get '/getvalue' => sub { 
    my $c   = shift;
    open(my $fh, '<:encoding(UTF-8)', $datfile) or die "Could not open '$datfile' $!";
    my $value = <$fh>;
    chomp $value;
    $c->render(text => "$value");
};

app->start;


__DATA__

@@ live.html.ep
<html lang="us">
<head>
  <meta charset="utf-8">
  <title>Dynamic Live Chart</title>
  <script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
  <script src="http://code.highcharts.com/highcharts.js"></script>
  <script>
    $(document).ready(function() {
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });

        var chart;
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                type: 'spline',
                marginRight: 10,
                events: {
                    load: function() {

                        // set up the updating of the chart each second
                        var series = this.series[0];
                        var y = 0; 
                        setInterval(function() {
                            var x = (new Date()).getTime(); // current time
                            $.get('/getvalue', function(data) {
                              var oldy = y;
                              y = parseInt(data);
                              series.addPoint([x, y], true, true);
                            });
                        }, 1000);
                    }
                }
            },
            title: {
                text: 'Dynamic Chart live'
            },
            xAxis: {
                type: 'datetime',
                tickPixelInterval: 150
            },
            yAxis: {
                title: {
                    text: 'Values'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            plotOptions: {
                line: {
                    marker: {
                        enabled: false
                    }
                }
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.series.name +'</b><br/>'+
                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+
                        Highcharts.numberFormat(this.y, 2);
                }
            },
            legend: {
                enabled: false
            },
            exporting: {
                enabled: false
            },
            series: [{
                name: 'Value',
                data: (function() {
                    // generate an array of random data
                    var data = [],
                        time = (new Date()).getTime(),
                        i;
                    for (i = -19; i <= 0; i++) {
                        data.push({
                            x: time + i * 1000,
                            y: 0,
                        });
                    }
                    return data;
                })()
            }]
        });
    });
  </script>
</head>
<body> 
<div id="container"></div>
</body>
</html>
