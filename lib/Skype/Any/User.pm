package Skype::Any::User;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;
use Skype::Any::Chat;

sub send_message {
    my ($self, $message) = @_;

    my $chatname = do {
        my $res = $self->send_command('CHAT CREATE %s', $self->{id});
        (split /\s+/, $res, 4)[1];
    };
    my $chat = Skype::Any::Chat->new($chatname);
    $chat->send_message($message);
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
