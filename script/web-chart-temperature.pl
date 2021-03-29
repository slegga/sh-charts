#!/usr/bin/env perl

use Mojo::Base -strict;
use Mojo::File 'path';
use lib 'lib';
my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
   my @cats = @$gitdir;
   while (my $cd = pop @cats) {
       if ($cd eq 'git') {
           $gitdir = Mojo::File::path(@cats,'git');
           last;
       }
   }
   $lib =  $gitdir->child('utilities-perl','lib')->to_string; #return utilities-perl/lib
};
use lib $lib;
use SH::UseLib;
use Model::GetCommonConfig;

use SH::Charts;
use Mojolicious::Commands;
$ENV{CHART_CONFIG_FILE} = $ENV{HOME} .'/etc/chart-temperature.conf';
# Start command line interface for application
Mojolicious::Commands->start_app('SH::Charts');

=head1 NAME

web-myapp.pl - Starter program for webserver

=head1 DESCRIPTION

Starter program nothing else.

=head1 Testing

TEST_USER=me morbo CONFIG_DIR=t/etc script/web-myapp.pl

http://127.0.0.1:3000/privat/index
