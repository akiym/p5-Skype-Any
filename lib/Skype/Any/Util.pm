package Skype::Any::Util;
use strict;
use warnings;
use parent qw/Exporter/;
use Carp ();

our @EXPORT_OK = qw/parse_response is_error/;

sub parse_response {
    my ($res, $limit) = @_;
    $limit ||= 4;

    return split /\s+/, $res, $limit;
}

sub is_error {
    my ($res) = @_;
    if ($res =~ /^ERROR/) {
        my ($obj, $code, $description) = parse_response($res, 3);
        Carp::carp($description);
        return 1;
    }
    return 0;
}

1;
