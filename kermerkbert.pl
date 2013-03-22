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
	if($message->{body} =~ /^\s*add\s+(\w+)\s*$/i) {
	    $self->{accounts}->{$1} = $message->{who};
	    return "Added account $1";
	} elsif ($message->{body} =~ /^\s*delete\s+(\w+)\s*$/i){
	    unless (exists $self->{accounts}->{$1}) {
		return "Not following $1";
	    } elsif ($self->{accounts}->{$1} eq $message->{who}) {
		delete $self->{accounts}->{$1};
		return "Account $1 deleted";
	    } else {
		return "Error, unauthorized to delete account $1.";
	    }
	} elsif ($message->{body} =~ /list/i){
	    my $msg = "is following";
	    if (scalar keys %{$self->{accounts}} > 0) {
		foreach (keys %{$self->{accounts}}) {
		    $msg .= " $_,";
	    }
		chop $msg;
	    } else {
		$msg .= " nobody. Use ".$self->{args}->{nick}.": add <username>";
	    }
	     return $msg;
	} else {
	    $self->emote(body =>" thinks you should shert the ferk erp.",
		channel => $message->{channel});
	}
	print "someone tried to talk to us: ".$message->{who}."\n";
    }
    return undef;
}

sub tick {
    print "tick called \n";
    return 0;
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
my %accounts;
my $bot = Bot->new(channels => [$args->{channel}],
		   server => $args->{server},
		   nick => $args->{nick},
		   name => $args->{nick},
		   ssl => 1,
		   port => 6697,
		   args => $args,
		   accounts => \%accounts)->run();
