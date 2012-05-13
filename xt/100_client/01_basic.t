use strict;
use warnings;
use Test::More;
use Skype::Any;

{
    my $skype = Skype::Any->new;
    isa_ok $skype, 'Skype::Any';

    ok defined $Skype::Any::API::CLIENT;
}

ok not defined $Skype::Any::API::CLIENT;

done_testing;
