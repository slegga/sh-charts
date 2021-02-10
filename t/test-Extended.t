use Mojo::Base -strict;
use Test::More;
use Mojo::Date;
use lib 'lib';

my $dateclass = Mojo::Date->with_roles('+Extended');
my $date = $dateclass->from_short_date('1/1-00');
is($date->epoch1000, 946681200000, 'Right value for from_short_date');
my $seconds = $dateclass->from_time_interval('8:30')->epoch;
is( $seconds,510,'Right interval');


done_testing;