package Skype::Any::VoiceMail;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('VOICEMAIL', $property, $value);
}

1;
__END__

=head1 NAME

Skype::Any::VoiceMail -

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $voicemail = Skype::Any::VoiceMail->new()

=item $voicemail->property($property)

=item $voicemail->property($property, $value)

=back

=cut
