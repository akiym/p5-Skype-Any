package Skype::Any::Property;
use strict;
use warnings;
use Carp ();
use Skype::Any::API;

sub new {
    my ($class, $id) = @_;

    Carp::croak('id is required.') unless defined $id;

    bless {
        id => $id,
    }, $class;
}

sub register_handler {
    my ($class, %args) = @_;
    no strict 'refs';
    for my $prop (keys %args) {
        push @{${"$class\::_handler"}->{$prop}}, $args{$prop};
    }
}

sub handler {
    my ($self, $prop, @args) = @_;
    no strict 'refs';
    my $class = ref $self || $self;
    for my $code (@{${"$class\::_handler"}->{$prop}}) {
        $code->($self, @args);
    }
}

sub send_command {
    my ($self, $command) = @_;
    Skype::Any::API->send_command($command);
}

sub property {
    my ($self, $obj, $property) = @_;
    $property = uc $property;

    my $res = $self->send_command("GET $obj $self->{id} $property");
    $self->_error($res);

    (split /\s+/, $res, 4)[3];
}

sub _error {
    my ($self, $res) = @_;
    if ($res =~ /^ERROR/) {
        my ($obj, $code, $description) = split /\s+/, $res, 3;
        Carp::carp($description);
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
