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

    my $name = $args{name} || __PACKAGE__ . '/' . $Skype::Any::VERSION;
    my $protocol = $args{protocol} || 8;

    my $api = Skype::Any::API->new(
        name     => $name,
        protocol => $protocol,
    );

    bless {}, $class;
}

sub _register_handler {
    my ($self, $class, %args) = @_;
    $class = "Skype::Any::$class";
    $class->register_handler(%args);
}

for my $class (qw/User Profile Call Message Chat ChatMember ChatMessage VoiceMail SMS Application Group FileTransfer/) {
    my $meth = lc $class;
    no strict 'refs';
    *{__PACKAGE__ . '::' . $meth} = sub {
        my $self = shift;
        if (@_ == 1) {
            $self->_register_handler($class, _ => $_[0]);
        } else {
            $self->_register_handler($class, @_);
        }
    };
}

sub message_received {
    my ($self, $code) = @_;
    my $wrapped_code = sub {
        my ($chatmessage, $status) = @_;
        if ($status eq 'RECEIVED') {
            return $code->($chatmessage, $status);
        }
    };
    $self->_register_handler('ChatMessage', status => $wrapped_code);
}

sub notify {
    my ($self, $code) = @_;
    $self->_register_handler('Property', _ => $code);
}

sub run          { Skype::Any::API->run }
sub disconnect   { Skype::Any::API->disconnect }
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

=item $skype->disconnect();

=item $skype->is_running();

=item $skype->send_command($command);

=back

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym at gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
