package Skype::Any::User;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;
use Skype::Any::Chat;
use Skype::Any::Util qw/parse_response/;

sub chat {
    my $self = shift;
    my $chatname = do {
        my $command = sprintf 'CHAT CREATE %s', $self->id;
        my $res = $self->send_command($command);
        (parse_response($res))[1];
    };
    Skype::Any::Chat->new($chatname);
}

sub send_message {
    my ($self, $message) = @_;
    $self->chat->send_message($message);
}

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('USER', $property, $value);
}

for my $property (qw/hascallequipment is_video_capable is_voicemail_capable isauthorized isblocked can_leave_vm is_cf_active/) {
    no strict 'refs';
    *{$property} = sub {
        my $self = shift;
        my $res = $self->property($property);
        $res eq 'TRUE' ? 1 : 0;
    };
}

1;
__END__

=head1 NAME

Skype::Any::User - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $user = Skype::Any::User->new()

=item $user->send_message($message)

=item $user->property($property)

=item $user->property($property, $value)

=back

=cut
