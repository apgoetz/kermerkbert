#!/usr/bin/env perl
use REST::Client;
use JSON;
package Bot;
use base qw(Bot::BasicBot);
use strict;
use warnings;

sub connected {
    my $self = shift;
    my $args = $self->{args};
    $self->say(who => "nickserv", channel => "msg", body=> "identify ".$args->{passwd});
    $self->log( "am now connected!\n");

}

sub said {
    my $self = shift;
    my $message = shift;
    if($message->{address} and $message->{who} !~ /nickserv/i) {
    print "someone tried to talk to us: ".$message->{who}."\n";
    $self->emote(channel => $self->{args}->{channel}, body => "rages: shut up!");
    }
}

sub tick {
    print "tick called \n";
    return 5;
}

sub help {
    return "Sorry, kermerkbert has trouble herlping perple.";
}
package main;
sub printhelp {
    my $documentation = <<EOF;
Usage: $0 server channel nick passwd imgursecret	
EOF
print $documentation;
    exit 0;
}
sub parseargs {
    printhelp unless (scalar @ARGV == 5);
    my %arghash = ("server" => $ARGV[0], 
		   "channel" => $ARGV[1], 
		   "nick" => $ARGV[2],
		   "passwd" => $ARGV[3],
		   "imgursecret" => $ARGV[4]);
    return \%arghash;
}
my $args = parseargs;

my $bot = Bot->new(channels => [$args->{channel}],
			     server => $args->{server},
			     nick => $args->{nick},
			     name => $args->{nick},
			     ssl => 1,
			     port => 6697,
			     args => $args)->run();
