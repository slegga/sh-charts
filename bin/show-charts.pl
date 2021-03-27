#!/usr/bin/env perl

use strict;
use warnings;

use Mojo::File qw(curfile);
use lib curfile->dirname->sibling('lib')->to_string;
use Mojolicious::Commands;
use lib 'lib';

=head1 NAME

show-charts.pl

=head1 SYNOPSIS

    CHART_CONFIG_FILE=manualtest/chess.conf morbo bin/show-graphs.pl
    CHART_CONFIG_FILE=manualtest/temperature.conf morbo bin/show-graphs.pl
    CHART_CONFIG_FILE=manualtest/weight.conf morbo bin/show-graphs.pl

=head1 DESCRIPTION

Show web chart. Based on highcharts.

=cut

# Start command line interface for application
die "Must set CHART_CONFIG_FILE" if ! $ENV{CHART_CONFIG_FILE};
Mojolicious::Commands->start_app('SH::Charts');
