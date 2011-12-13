package Skype::Any::Chat;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub send_message {
    my ($self, $message) = @_;
    $message = '' unless defined $message;

    $self->send_command("CHATMESSAGE $self->{id} $message");
}

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('CHAT', $property, $value);
}

for my $property (qw/bookmarked/) {
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

Skype::Any::Chat -

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $chat = Skype::Any::Chat->new()

=item $chat->send_message($message)

=item $chat->property($property)

=item $chat->property($property, $value)

=back

=cut
