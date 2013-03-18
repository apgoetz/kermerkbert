#!/usr/bin/env perl
use REST::Client;
use Bot::BasicBot;
use JSON;
use strict;
use warnings;

sub help {
    my $documentation = <<EOF;
Usage: $0 server channel nick passwd imgursecret	
EOF
print $documentation;
    exit 0;
}
sub parseargs {
    help unless (scalar @ARGV == 5);
    my %arghash = ("server" => $ARGV[0], 
		   "channel" => $ARGV[1], 
		   "nick" => $ARGV[2],
		   "passwd" => $ARGV[3],
		   "imgursecret" => $ARGV[4]);
    return \%arghash;
}

my $args = parseargs;
