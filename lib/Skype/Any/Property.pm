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
    my $self = shift;
    Skype::Any::API->send_command(@_);
}

sub property {
    my ($self, $obj, $property, $value) = @_;
    $property = uc $property;

    my $res;
    if (defined $value) {
        $res = $self->send_command('SET %s %s %s %s', $obj, $self->{id}, $property, $value);
    } else {
        $res = $self->send_command('GET %s %s %s', $obj, $self->{id}, $property);
    }

    if ($res =~ /^ERROR/) {
        my ($obj, $code, $description) = split /\s+/, $res, 3;
        Carp::carp($description);
    }

    (split /\s+/, $res, 4)[3];
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
