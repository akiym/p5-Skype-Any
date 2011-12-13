package Skype::Any::Application;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('APPLICATION', $property, $value);
}

1;
__END__

=head1 NAME

Skype::Any::Application -

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $application = Skype::Any::Application->new()

=item $application->property($property)

=item $application->property($property, $value)

=back

=cut
