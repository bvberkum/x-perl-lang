package XPD;
use base qw( CLI::Framework );

use strict;
use warnings;

use Storable 2.05 qw( store retrieve );

my $model;          # Model class for queue
my $serialize;
my $storable_file;  # File for serializing queue


sub usage_text {
    qq{
    $0 [--verbose|v]: 

    OPTIONS:
        --verbose -v:   be vebose

    ARGUMENTS (subcommands):
        console:        run interactively
        cmd-list:       list available commands
        query:                                    
    }
}

sub option_spec {
    [ 'verbose|v'       => 'be verbose' ],
    [ 'qin|i=s'         => 'start by loading a saved queue stored from a previous session' ],
    [ 'qout|o=s'        => 'optional file to use for serializing the queue' ],
}

sub validate_options {
    my ($self, $opts) = @_;
    
    # ...nothing to check for this application
}

sub command_map {
    console     => 'CLI::Framework::Command::Console',
    alias       => 'CLI::Framework::Command::Alias',
    'cmd-list'  => 'CLI::Framework::Command::List',
    query       => 'XPD::Command::query',
}

sub command_alias {
    sh  => 'console',
}

sub init {
    my ($self, $opts) = @_;

    # Get (new or saved) model object...
    if( $opts->{'qin'} ) {
        { no warnings;
          local $Storable::Eval = 1;          # (support coderefs for deserialization)
          $model = retrieve( $opts->{'qin'} );
        }
    }
    else {
        $model = XPD::Model->new();
    }
    # Store model object in shared cache...
    $self->cache->set( 'model' => $model );

    # Set file for storage of serialized queue...
    if( $opts->{'qout'} ) {
        $serialize = 1;
        $storable_file = $opts->{'qout'};
    }
    return 1;
}

END { # Check if we should serialize queue before exiting...
    if( $serialize ) {
        { no warnings;
          $Storable::Deparse = 1;                 # (support coderefs for serialization)
        }
        eval { my $result = store( $model, $storable_file ) };
        if( $@ ) {
            warn 'Storable error while trying to serialize model '.
                  "object: $!";
        }
    }
}

use XPD::Model;

use XPD::Command::query;

1;
