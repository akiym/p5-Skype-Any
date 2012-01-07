package Skype::Any::API::Linux;
use strict;
use warnings;
use AnyEvent;
use AnyEvent::DBus;
use Net::DBus::Skype::API;

sub new {
    my ($class, %args) = @_;

    my $client = Net::DBus::Skype::API->new(
        name     => $args{name},
        protocol => $args{protocol},
        notify   => $args{handler},
    );

    bless {
        client => $client,
    }, $class;
}

sub attach { shift->{client}->attach }

sub run          { AE::cv->recv }
sub is_running   { shift->{client}->is_running }
sub send_command { shift->{client}->send_command(@_) }

1;
