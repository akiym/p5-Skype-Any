package Skype::Any::API;
use strict;
use warnings;
use Carp ();

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

our $CLIENT;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    my $self = bless \%args, $class;
    $self->init;

    $self;
}

sub init {
    my $self = shift;

    if ($^O eq 'MSWin32') {
        require Skype::Any::API::Windows;
        $CLIENT = Skype::Any::API::Windows->new(
            protocol => $self->{protocol},
        );
    } elsif ($^O eq 'darwin') {
        require Skype::Any::API::Mac;
        $CLIENT = Skype::Any::API::Mac->new(
            name     => $self->{name},
            protocol => $self->{protocol},
        );
    } elsif ($^O eq 'linux') {
        require Skype::Any::API::Linux;
        $CLIENT = Skype::Any::API::Linux->new(
            name     => $self->{name},
            protocol => $self->{protocol},
        );
    }
    Carp::croak('Your platform is not supported.') unless defined $CLIENT;

    $CLIENT->attach;
}

sub handler {
    my ($self, $notification) = @_;
    my ($command, $id, $property, $value) = split /\s+/, $notification, 4;

    Skype::Any::Property->handler(_ => $command, $id, $property, $value);
    if ($command eq 'USER') {
        my $user = Skype::Any::User->new($id);
        $user->handler(_ => $property, $value);
        if ($property eq 'ONLINESTATUS') {
            $user->handler(onlinestatus => $value);
        } elsif ($property eq 'RECEIVEDAUTHREQUEST') {
            $user->handler(receivedauthrequest => $value);
        } elsif ($property eq 'MOOD_TEXT' || $property eq 'RICH_MOOD_TEXT') {
            $user->handler(mood_text => $value);
        }
    } elsif ($command eq 'PROFILE') {
        my $profile = Skype::Any::Profile->new();
        $profile->handler(_ => $property, $value);
    } elsif ($command eq 'CALL') {
        my $call = Skype::Any::Call->new($id);
        $call->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $call->handler(status => $value);
        } elsif ($property eq 'VIDEO_STATUS') {
            $call->handler(video_status => $value);
        } elsif ($property eq 'VIDEO_SEND_STATUS') {
            $call->handler(video_send_status => $value);
        } elsif ($property eq 'VIDEO_RECEIVE_STATUS') {
            $call->handler(video_receive_status => $value);
        } elsif ($property eq 'VAA_INPUT_STATUS') {
            $call->handler(vaa_input_status => $value);
        } elsif ($property eq 'TRANSFER_STATUS') {
            $call->handler(transfer_status => $value);
        } elsif ($property eq 'DTMF') {
            $call->handler(dtmf => $value);
        } elsif ($property eq 'SEEN') {
            $call->handler(seen => $value);
        }
    } elsif ($command eq 'MESSAGE') {
        my $message = Skype::Any::Message->new($id);
        $message->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $message->handler(status => $value);
        }
    } elsif ($command eq 'CHAT') {
        my $chat = Skype::Any::Chat->new($id);
        $chat->handler(_ => $property, $value);
        if ($property eq 'MEMBERS') {
            $chat->handler(members => $value);
        } elsif ($property eq 'OPEND' || $property eq 'CLOSED') {
            $chat->handler(opend => $value);
        }
    } elsif ($command eq 'CHATMEMBER') {
        my $chatmember = Skype::Any::ChatMember->new($id);
        $chatmember->handler(_ => $property, $value);
        if ($property eq 'ROLE') {
            $chatmember->handler(role => $value);
        }
    } elsif ($command eq 'CHATMESSAGE') {
        my $chatmessage = Skype::Any::ChatMessage->new($id);
        $chatmessage->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $chatmessage->handler(status => $value);
        }
    } elsif ($command eq 'VOICEMAIL') {
        my $voicemail = Skype::Any::VoiceMail->new($id);
        $voicemail->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $voicemail->handler(status => $value);
        }
    } elsif ($command eq 'SMS') {
        my $sms = Skype::Any::SMS->new($id);
        $sms->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $sms->handler(status => $value);
        } elsif ($property eq 'TARGET_STATUSES') {
            $sms->handler(target_statuses => $value);
        }
    } elsif ($command eq 'APPLICATION') {
        my $application = Skype::Any::Application->new($id);
        $application->handler(_ => $property, $value);
        if ($property eq 'CONNECTING') {
            $application->handler(connecting => $value);
        } elsif ($property eq 'STREAMS') {
            $application->handler(streams => $value);
        } elsif ($property eq 'SENDING') {
            $application->handler(sending => $value);
        } elsif ($property eq 'RECEIVED') {
            $application->handler(received => $value);
        } elsif ($property eq 'DATAGRAM') {
            $application->handler(datagram => $value);
        }
    } elsif ($command eq 'GROUP') {
        my $group = Skype::Any::Group->new($id);
        $group->handler(_ => $property, $value);
        if ($property eq 'NROFUSERS') {
            $group->handler(nrofusers => $value);
        } elsif ($property eq 'VISIBLE') {
            $group->handler(visible => $value);
        } elsif ($property eq 'EXPANDED') {
            $group->handler(expanded => $value);
        }
    } elsif ($command eq 'FILETRANSFER') {
        my $filetransfer = Skype::Any::FileTransfer->new($id);
        $filetransfer->handler(_ => $property, $value);
        if ($property eq 'STATUS') {
            $filetransfer->handler(status => $value);
        }
    }
}

sub run          { $CLIENT->run }
sub is_running   { $CLIENT->is_running }
sub send_command {
    my $self = shift;
    my $command = @_ > 1 ? sprintf(shift, @_) : $_[0];
    $CLIENT->send_command($command);
}

1;
