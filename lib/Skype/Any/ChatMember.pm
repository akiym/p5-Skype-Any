package Skype::Any::ChatMember;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub alter {
    my ($self, $property, $value) = @_;
    $self->SUPER::alter('CHATMEMBER', $property, $value);
}

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('CHATMEMBER', $property, $value);
}

for my $property (qw/is_active/) {
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

Skype::Any::ChatMember -

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $chatmember = Skype::Any::ChatMember->new()

=item $chatmember->property($property)

=item $chatmember->property($property, $value)

=back

=cut
