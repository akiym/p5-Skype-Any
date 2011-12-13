package Skype::Any::Profile;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub property {
    my ($self, $property, $value) = @_;
    $property = uc $property;

    my $res = $self->send_command("GET PROFILE $property");
    $self->_error($res);

    (split /\s+/, $res, 3)[2];
}

1;
__END__

=head1 NAME

Skype::Any::Profile - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $profile = Skype::Any::Profile->new()

=item $profile->property($property)

=item $profile->property($property, $value)

=back

=cut
