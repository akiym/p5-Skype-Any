package Skype::Any::Handler;
use strict;
use warnings;

our $HANDLER;

sub register {
    my ($class, $klass, $args) = @_;
    for my $property (keys %$args) {
        push @{$HANDLER->{$klass}{$property}}, $args->{$property};
    }
}

sub handler {
    my ($class, $klass, $property) = @_;
    my $handler = $HANDLER->{$klass}{$property} || [];
    return @$handler;
}

1;
