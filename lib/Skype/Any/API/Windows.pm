package Skype::Any::API::Windows;
use strict;
use warnings;
use SkypeAPI;

sub new {
    my ($class, %args) = @_;

    my $client = SkypeAPI->new;
    $client->register_handler(sub { shift; $args{handler}->(@_) });

    bless {
        client   => $client,
        protocol => $args{protocol},
    }, $class;
}

sub attach {
    my $self = shift;
    $self->{client}->attach;

    $self->send_command("PROTOCOL $self->{protocol}");
}

sub run          { shift->{client}->listen }
sub disconnect   { shift->{client}->stop_listen }
sub is_running   { shift->{client}->is_available }
sub send_command {
    my ($self, $string) = @_;
    my $command = $self->{client}->create_command({string => $string});
    $self->{client}->send_command($command);
}

1;
