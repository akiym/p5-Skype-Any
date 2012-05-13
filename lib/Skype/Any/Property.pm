package Skype::Any::Property;
use strict;
use warnings;
use Carp ();
use Skype::Any::API;
use Skype::Any::Handler;

sub new {
    my ($class, $id) = @_;

    Carp::croak('id is required.') unless defined $id;

    bless {
        id => $id,
    }, $class;
}

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

sub alter {
    my ($self, $obj, $property, $value) = @_;
    $property = uc $property;

    my $res;
    if (defined $value) {
        $res = $self->send_command('ALTER %s %s %s %s', $obj, $self->{id}, $property, $value);
    } else {
        $res = $self->send_command('ALTER %s %s %s', $obj, $self->{id}, $property);
    }

    if ($res =~ /^ERROR/) {
        my ($obj, $code, $description) = split /\s+/, $res, 3;
        Carp::carp($description);

        return;
    }

    1;
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
