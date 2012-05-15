package Skype::Any::SMS;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('SMS', $property, $value);
}

for my $property (qw/is_failed_unseen/) {
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

Skype::Any::SMS -

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $sms = Skype::Any::SMS->new()

=item $sms->property($property)

=item $sms->property($property, $value)

=back

=cut
