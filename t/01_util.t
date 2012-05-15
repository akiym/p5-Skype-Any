use strict;
use warnings;
use Test::More;
use Skype::Any::Util qw/parse_response is_error/;

subtest 'parse_response()' => sub {
    is_deeply [parse_response('USER echo123 LASTONLINETIMESTAMP 1105764678')],
        ['USER', 'echo123', 'LASTONLINETIMESTAMP', '1105764678'];
    is_deeply [parse_response('USER echo123 FULLNAME Echo Test Service')],
        ['USER', 'echo123', 'FULLNAME', 'Echo Test Service'];
    is_deeply [parse_response('PROFILE MOOD_TEXT Life is great and then you...', 3)],
        ['PROFILE', 'MOOD_TEXT', 'Life is great and then you...'];
};

subtest 'is_error()' => sub {
    my $buffer = '';
    open my $fh, '>', \$buffer or die $!;
    local *STDERR = $fh;

    ok is_error('ERROR 2 Unknown command');

    close $fh;

    like $buffer, qr/Unknown command/;

    ok not is_error('CHATMESSAGE 864 BODY Test message after being edited');
};

done_testing;
