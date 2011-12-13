package Skype::Any::FileTransfer;
use strict;
use warnings;
use parent qw/Skype::Any::Property/;

sub property {
    my ($self, $property, $value) = @_;
    $self->SUPER::property('FILETRANSFER', $property, $value);
}

1;
__END__

=head1 NAME

Skype::Any::FileTransfer - 

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item my $filetransfer = Skype::Any::FileTransfer->new()

=item $filetransfer->property($property)

=item $filetransfer->property($property, $value)

=back

=cut
