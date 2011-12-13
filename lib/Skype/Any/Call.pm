package Skype::Any::Call;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('CALL', $property, $value);
}

for my $property (qw/vaa_input_status/) {
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

Skype::Any::Call - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $call = Skype::Any::Call->new()

=item $call->property($property)

=item $call->property($property, $value)

=back

=cut
