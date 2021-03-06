package Graphs;

use Mojo::Base 'Mojolicious', -signatures;
use Data::Dumper;
use YAML::Syck 'LoadFile';
use Text::CSV qw( csv );
use Math::BigInt;
use Mojo::File 'path';
my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
    my @cats = @$gitdir;
    while (my $cd = pop @cats) {
        if ($cd eq 'git') {
            $gitdir = path(@cats,'git');
            last;
        }
    }
    $lib =  $gitdir->child('utilities-perl','lib')->to_string; #return utilities-perl/lib
};

=head1 NAME

Graphs

=head1 SYNOPSIS

    use Mojolicious::Commands;
    use lib 'lib';
    $ENV{GRAPH_CONFIG_FILE}= 't/etc/my-graph.yml'
    # Start command line interface for application
    Mojolicious::Commands->start_app('Graphs');

=head1 DESCRIPTION

Startup script for running daemon for a graph.

=head1 METHODS

=head2 startup

Called by parent.

=cut



# Answer to /
sub startup ($self) {
    my $mydat;
    {

    # Everything can be customized with options
    die "Missing GRAPH_CONFIG_FILE" if ! $ENV{GRAPH_CONFIG_FILE};
    my $config = $self->plugin(Config => {file => $ENV{GRAPH_CONFIG_FILE}});

#    my $datfile = "$ENV{HOME}/googledrive/data/chess/spill-tid-fredrik-pappa.yml";
        my $datfile = $config->{datafile};
        for ($datfile) {
            if ( /ml$/) {
                $YAML::Syck::ImplicitTyping=1;
                $mydat = LoadFile($datfile);
            } elsif (/csv$/) {
                warn "$datfile is read";
                $mydat = csv (in => $datfile, sep_char=>";" );    # as array of array ref
            } else {
                die "Unknown filetype $_";
            }
        }
    }

    #handle dates
    my $date_c = Mojo::Date->with_roles('+Extended');

    say Dumper $mydat;
    my $y;
    for my $r(@$mydat) {
        my $nr=[0,0];
        for my $i (0 .. $#$r) {
            if ($r->[$i] =~ /\d-\d/) {
                $nr->[$i] = int($date_c->from_short_date($r->[$i])->epoch * 1000);
            }
            elsif ($r->[$i] =~ /^\d+:\d+$/) {
                $nr->[$i] = $date_c->from_time_interval($r->[$i])->epoch;
            }
            elsif($r->[$i]=~/^\d{9,10}$/) {
                $nr->[$i] = $r->[$i] * 1000;
            }
            else {
                $nr->[$i] = $r->[$i];
            }
        }
        push @$y,$nr;
    }

#    say Dumper $y;

    my $r = $self->routes;

    $r->get( '/' => sub {
        my $c = shift;

        {
            $Data::Dumper::Terse = 1;        # don't output names where feasible
            $Data::Dumper::Indent = 0;       # turn off all pretty print
            my $mydata= Dumper $y;
            $mydata=~ s/\'(\d+(.\d+)?)\'/$1/g;
            say STDERR $mydata;
            $c->stash($c->config);
            $c->stash(mydata=>$mydata);
        }
        $c->render(template => 'live', format => 'html');
    });
    $r->namespaces(['Graphs']);
}

1;


