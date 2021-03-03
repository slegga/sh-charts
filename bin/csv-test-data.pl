#!/usr/bin/env perl
use Mojo::Base -strict;
use Text::CSV qw( csv );
use Data::Dumper;
use v5.26;
use Mojo::Date;
use lib 'lib';
my $date_c = Mojo::Date->with_roles('+Extended');

sub string2number {
    my $datesring = shift;

}

my $x = csv( in=>$ARGV[0],sep_char=>";" );    # as array of array ref

say Dumper $x;
my $y;
for my $r(@$x) {
    if ($r->[0] =~ /\d-\d/) {
        $r->[0] = $date_c->from_short_date($r->[0])->epoch1000;
    }
    if ($r->[1] =~ /^\d+:\d{1,2}$/) {
        $r->[1] = $date_c->from_time_interval($r->[1])->epoch;
    }
    push @$y,$r;
}

say Dumper $y;