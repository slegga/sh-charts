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
                type: 'bar'
            },
            title: {
                text: 'Vekt'
            },
            xAxis: {
                categories: ['Apples', 'Bananas', 'Oranges']
            },
            yAxis: {
                title: {
                    text: 'Fruit eaten'
                }
            },
            series: [{
                name: 'Jane',
                data: [1, 0, 4]
            }, {
                name: 'John',
                data: [5, 7, 3]
            }]
        });
    });
</script>
</head>
<body>
<div id="container" style="width:100%; height:400px;"></div>
</body>
</html>
