#!/usr/bin/env perl

use strict;
use warnings;

use Mojo::File qw(curfile);
use lib curfile->dirname->sibling('lib')->to_string;
use Mojolicious::Commands;
use lib 'lib';

=head1 NAME

show-graphs.pl

=head1 SYNOPSIS

    GRAPH_CONFIG_FILE=manualtest/chess.conf morbo bin/show-graphs.pl
    GRAPH_CONFIG_FILE=manualtest/temperature.conf morbo bin/show-graphs.pl
    GRAPH_CONFIG_FILE=manualtest/weight.conf morbo bin/show-graphs.pl

=head1 DESCRIPTION

Show web graph. Based on highcharts.

=cut

# Start command line interface for application
die "Must set GRAPH_CONFIG_FILE" if ! $ENV{GRAPH_CONFIG_FILE};
Mojolicious::Commands->start_app('Graphs');