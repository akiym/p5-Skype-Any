package Skype::Any::Message;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('MESSAGE', $property, $value);
}

sub from_handle   { shift->property('partner_handle') }
sub from_dispname { shift->property('partner_dispname') }

1;
__END__

=head1 NAME

Skype::Any::Message - 

=head1 DESCRIPTION

deprecated.

=head1 METHODS

=over 4

=item my $message = Skype::Any::Message->new()

=item $message->property($property)

=item $message->property($property, $value)

=back

=cut
