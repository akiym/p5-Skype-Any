package Skype::Any::Group;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub alter {
    my ($self, $property, $value) = @_;
    $self->SUPER::alter('GROUP', $property, $value);
}

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('GROUP', $property, $value);
}

1;
__END__

=head1 NAME

Skype::Any::Group - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $group = Skype::Any::Group->new()

=item $group->property($property)

=item $group->property($property, $value)

=back

=cut
