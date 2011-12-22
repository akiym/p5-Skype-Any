package Skype::Any::API::Mac;
use strict;
use warnings;
use Cocoa::Skype;
use Cocoa::EventLoop;

sub new {
    my ($class, %args) = @_;

    my $client = Cocoa::Skype->new(
        name => $args{name},
        on_attach_response => sub {
            my ($self, $code) = @_;
            if ($code == 1) {
                $self->send("PROTOCOL $args{protocol}");
            }
        },
        on_notification_received => $args{handler},
    );

    bless {
        client => $client,
    }, $class;
}

sub attach {
    my $self = shift;
    $self->{client}->connect;
}

sub run          { Cocoa::EventLoop->run }
sub disconnect   { shift->{client}->disconnect }
sub is_running   { shift->{client}->isRunning }
sub send_command { shift->{client}->send(@_) }

1;
