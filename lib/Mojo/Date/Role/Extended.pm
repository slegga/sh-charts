package Mojo::Date::Role::Extended;
use Mojo::Base -role, -signatures;

=head1 NAME

Mojo::Date::Role::Extended - More methods for Mojo::Date

=head1 SYNOPSIS

    use Mojo::Date;
    use lib 'lib';
    my $class = Mojo::Date->with_roles('+Extended');
    my $date = $class->from_short_date('1/1-00')
    say $date->epoch1000;
    my $seconds = $class->from_time_interval('8:30')->epoch;
    say $seconds;

=head1 DESCRIPTION

Needed methods for Mojo::Date

=head1 METHODS

=head2 from_short_date

Take a string on the format DD/MM-YY and return a Mojo::Date object for same locale time zone,

=cut

requires('epoch','new');

sub from_short_date($class,$string) {
    if ($string =~ /(\d+)\/(\d+)-(\d+)/) {
        my ($mday,$mon,$year) = ($1,$2,$3);
        return $class->new("20$year-$mon-".$mday."T00:00:00+01:00");
    } else {
        die "Wrong format $string: should be like 1/1-00";
    }
}

=head2 from_time_interval

Take a string on the format MI::SS and return a Mojo::Date object,
Use to gether with epoch and you get a

=cut

sub from_time_interval($class,$string) {
    if ($string =~ /((\d+):)?(\d+)/) {
        my ($min,$sec) = ($2,$3);
        return $class->new($min * 60 + $sec);
    } else {
        die "Wrong format $string: should be like 0:00";
    }
}

=head2 epoch1000

Return epoch * 1000

=cut

sub epoch1000($self) {
    return $self->epoch * 1000;
}

1;
