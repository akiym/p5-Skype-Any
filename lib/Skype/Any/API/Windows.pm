package Skype::Any::API::Windows;
use strict;
use warnings;
use SkypeAPI;

sub new {
    my ($class, %args) = @_;

    my $client = SkypeAPI->new;

    my $protocol = $args{protocol} || 8;

    bless {
        client   => $client,
        protocol => $protocol,
    }, $class;
}

sub notify {
    my ($self, $code) = @_;
    $self->{client}->register_handler(sub { shift; $code->(@_) });
}

sub attach {
    my $self = shift;
    $self->{client}->attach;

    my $command = $self->{client}->create_command({string => "PROTOCOL $self->{protocol}"});
    $self->{client}->send_command($command);
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
