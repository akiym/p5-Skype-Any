package Skype::Any::API::Mac;
use strict;
use warnings;
use Cocoa::Skype;

sub new {
    my ($class, %args) = @_;

    my $client = Cocoa::Skype->new(
        name     => $args{name},
        protocol => $args{protocol},
    );
    $client->attach;

    bless {
        client => $client,
    }, $class;
}

sub notify {
    my ($self, $code) = @_;
    $self->{client}->notify($code);
}

sub run          { shift->{client}->run }
sub disconnect   { shift->{client}->disconnect }
sub is_running   { shift->{client}->is_running }
sub send_command { shift->{client}->send_command(@_) }

1;
