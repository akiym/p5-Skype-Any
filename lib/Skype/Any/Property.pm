package Skype::Any::Property;
use strict;
use warnings;
use Carp ();
use Skype::Any::API;
use Skype::Any::Handler;
use Skype::Any::Util qw/parse_response is_error/;

sub new {
    my ($class, $id) = @_;

    Carp::croak('id is required.') unless defined $id;

    bless {
        id => $id,
    }, $class;
}

sub id { $_[0]->{id} }

sub register_handler {
    my ($klass, %args) = @_;
    Skype::Any::Handler->register($klass => \%args);
}

sub handler {
    my ($self, $property, @args) = @_;
    my $klass = ref $self || $self;
    for my $code (Skype::Any::Handler->handler($klass => $property)) {
        $code->($self, @args);
    }
}

sub send_command {
    my $self = shift;
    Skype::Any::API->send_command(@_);
}

sub _get_property {
    my ($self, $obj, $property) = @_;
    my $command = sprintf 'GET %s %s %s', $obj, $self->id, $property;
    return $self->send_command($command);
}

sub _set_property {
    my ($self, $obj, $property, $value) = @_;
    my $command = sprintf 'SET %s %s %s %s', $obj, $self->id, $property, $value;
    return $self->send_command($command);
}

sub property {
    my $self = shift;

    my $res;
    if (@_ <= 3) {
        $res = $self->_get_property(@_);
    } else {
        $res = $self->_set_property(@_);
    }

    if (!is_error($res)) {
        return (parse_response($res))[3];
    } else {
        return;
    }
}

sub AUTOLOAD {
    my $property = our $AUTOLOAD;
    $property =~ s/.*:://;
    {
        no strict 'refs';
        *{$property} = sub {
            my $self = shift;
            $self->property($property, @_);
        };
    }
    goto &$property;
}

sub DESTROY {}

1;
__END__
