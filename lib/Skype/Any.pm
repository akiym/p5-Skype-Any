package Skype::Any;
use strict;
use warnings;
use 5.008001;
use Skype::Any::API;
use Skype::Any::Property;
use Skype::Any::User;
use Skype::Any::Profile;
use Skype::Any::Call;
use Skype::Any::Message;
use Skype::Any::Chat;
use Skype::Any::ChatMember;
use Skype::Any::ChatMessage;
use Skype::Any::VoiceMail;
use Skype::Any::SMS;
use Skype::Any::Application;
use Skype::Any::Group;
use Skype::Any::FileTransfer;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    Skype::Any::API->new(
        name     => __PACKAGE__ . '/' . $Skype::Any::VERSION,
        protocol => 8,
        %args,
    );

    bless {}, $class;
}

sub user {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::User->register_handler(_ => $_[0]);
    } else {
        Skype::Any::User->register_handler(@_);
    }
}

sub profile {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Profile->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Profile->register_handler(@_);
    }
}

sub call {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Call->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Call->register_handler(@_);
    }
}

sub message {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Message->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Message->register_handler(@_);
    }
}

sub chat {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Chat->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Chat->register_handler(@_);
    }
}

sub chatmember {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::ChatMember->register_handler(_ => $_[0]);
    } else {
        Skype::Any::ChatMember->register_handler(@_);
    }
}

sub chatmessage {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::ChatMessage->register_handler(_ => $_[0]);
    } else {
        Skype::Any::ChatMessage->register_handler(@_);
    }
}

sub voicemail {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::VoiceMail->register_handler(_ => $_[0]);
    } else {
        Skype::Any::VoiceMail->register_handler(@_);
    }
}

sub sms {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::SMS->register_handler(_ => $_[0]);
    } else {
        Skype::Any::SMS->register_handler(@_);
    }
}

sub application {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Application->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Application->register_handler(@_);
    }
}

sub group {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::Group->register_handler(_ => $_[0]);
    } else {
        Skype::Any::Group->register_handler(@_);
    }
}

sub filetransfer {
    my $self = shift;
    if (@_ == 1) {
        Skype::Any::FileTransfer->register_handler(_ => $_[0]);
    } else {
        Skype::Any::FileTransfer->register_handler(@_);
    }
}

sub message_received {
    my ($self, $code) = @_;
    my $wrapped_code = sub {
        my ($chatmessage, $status) = @_;
        if ($status eq 'RECEIVED') {
            return $code->($chatmessage, $status);
        }
    };
    $self->chatmessage(status => $wrapped_code);
}

sub notify {
    my ($self, $code) = @_;
    Skype::Any::Property->register_handler(_ => $code);
}

sub run          { Skype::Any::API->run }
sub is_running   { Skype::Any::API->is_running }
sub send_command { shift; Skype::Any::API->send_command(@_) }

1;
__END__

=head1 NAME

Skype::Any - 

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new();

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $skype = Skype::Any->new();

Create new instance of Skype::Any.

=over 4

=item name

=item protocol

=back

=item $skype->handler(sub { ... });

=item $skype->user(sub { ... });

=item $skype->user($name => sub { ... });

=item $skype->profile(sub { ... });

=item $skype->call(sub { ... });

=item $skype->chat(sub { ... });

=item $skype->chatmember(sub { ... });

=item $skype->chatmessage(sub { ... });

=item $skype->voicemail(sub { ... });

=item $skype->sms(sub { ... });

=item $skype->application(sub { ... });

=item $skype->group(sub { ... });

=item $skype->filetransfer(sub { ... });

=item $skype->message_received(sub { ... });

=item $skype->run()

=item $skype->is_running();

=item $skype->send_command($command);

=back

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym at gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
