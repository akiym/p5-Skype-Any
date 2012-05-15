use strict;
use warnings;
use Test::More;
use Skype::Any;
use Skype::Any::Handler;

use_ok($_) for qw/
    Skype::Any::Application
    Skype::Any::Call
    Skype::Any::Chat
    Skype::Any::ChatMember
    Skype::Any::ChatMessage
    Skype::Any::FileTransfer
    Skype::Any::Group
    Skype::Any::Message
    Skype::Any::Profile
    Skype::Any::SMS
    Skype::Any::User
    Skype::Any::VoiceMail
/;


{
    my $skype = Skype::Any->new;
    $skype->message_received(sub {});

    ok defined $Skype::Any::Handler::HANDLER;
}

ok not defined $Skype::Any::Handler::HANDLER;

done_testing;
