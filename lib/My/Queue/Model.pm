package My::Queue::Model;

use strict;
use warnings;
use Carp;

sub new {
    my ($class) = @_;
    bless { _items => [], _properties => {} }, $class;
}

sub add_tag_to_item {
    my ($self, $id, $tag) = @_;

    return unless defined $id && defined $tag;

    my @a = @{ $self->{_items} };
    my ($entry) = (grep { $_->{id} == $id } @a);
    push @{ $entry->{tags} }, $tag;

    return 1;
}

sub enqueue {
    my ($self, $item) = @_;

    return unless $item;

    my $id = _id($item);

    # Ensure item satisfies all queue properties...
    for my $p ( values %{ $self->{_properties} } ) {
        $p->($item) || return;
    }
    push @{ $self->{_items} }, { id => $id, data => $item, tags => [] };
    return $id;
}

sub _id {
    my $str = shift;
    my @s = split //, $str;
    return join( '', map { ord $_ } @s );
}

sub dequeue { shift @{ $_[0]->{_items} } }

sub items { @{$_[0]->{_items}} }

sub get_properties { keys %{$_[0]->{_properties}} }

sub set_property {
    my ($self, $name, $code) = @_;
    croak "queue property must be a CODE ref" unless ref $code eq 'CODE';
    $self->{_properties}->{$name} = $code;
    return 1;
}

1;
