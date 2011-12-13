package Skype::Any::ChatMessage;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;
use Skype::Any::Chat;

sub chat {
    my $self = shift;
    Skype::Any::Chat->new($self->chatname);
}

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('CHATMESSAGE', $property, $value);
}

for my $property (qw/is_editable/) {
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

Skype::Any::ChatMessage - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $chatmessage = Skype::Any::ChatMessage->new()

=item $chatmessage->chat()

=item $chatmessage->property($property)

=item $chatmessage->property($property, $value)

=back

=cut
