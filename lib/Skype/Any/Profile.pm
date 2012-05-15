package Skype::Any::Profile;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;
use Skype::Any::Util qw/parse_response is_error/;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub _get_property {
    my ($self, $property) = @_;
    my $command = sprintf 'GET PROFILE %s', $property;
    return $self->send_command($command);
}

sub _set_property {
    my ($self, $property, $value) = @_;
    my $command = sprintf 'SET PROFILE %s %s', $property, $value;
    return $self->send_command($command);
}

sub property {
    my $self = shift;

    my $res;
    if (@_ <= 1) {
        $res = $self->_get_property(@_);
    } else {
        $res = $self->_set_property(@_);
    }

    if (!is_error($res)) {
        return (parse_response($res, 3))[2];
    } else {
        return;
    }
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
