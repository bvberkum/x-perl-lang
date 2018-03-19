package XPD::Command::query;
use base qw( CLI::Framework::Command );

use strict;
use warnings;

sub usage_text {
    q{
    query [<query>]: query
    }
}

sub validate {
    my ($self, $cmd_opts, @args) = @_;

    die "No arguments given.  Usage:" . $self->usage_text() . "\n" unless @args;
}

sub option_spec {
    #[ 'tag=s@'   => 'item tag'  ],
}

sub run {
    return 'nothing';
}

1;
