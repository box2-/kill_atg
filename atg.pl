#!/usr/bin/perl -w

use strict;
use warnings;
use Irssi;
use vars qw/$NAME $VERSION %IRSSI/;
use threads;

$NAME = 'atg sucks';
$VERSION = "0.01";
%IRSSI = (
	name            => $NAME,
	version         => $VERSION,
	author          => 'box2',
	contact         => 'irc',
	download        => 'tba',
	description     => 'la di freakin da',
	license         => 'nouveau BSD',
);

# to add later, a list of things to randomly pick from
my $msg = "atg";
my $thr;

sub cmd_atg {
	# data    - user input after /cmd
	# server  - the active server window
	# witem   - the active window item (eg. channel, query)
	#	          (or undef if the window is empty)
	my ($data, $server, $witem) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to server");
		return;
	}

	# We have an active chat window
	if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
    # start the spam thread
    $thr = threads->create(sub {
      # Thread 'cancellation' signal handler
      $SIG{'KILL'} = sub { threads->exit(); };

      while(1) {
        # anywhere between 0 seconds and 12 hours (43200 seconds)
        my $timeout = int(rand(43200));
        Irssi::print("Starting ATG timer (".$timeout." seconds) in: ".$witem->{name});
        sleep($timeout);
        # we do split string incase of later ascii/banners
        foreach my $string (split "\n", $msg) {
          $witem->command("MSG ".$witem->{name}." ".$string);
        }
      }
    });
	} else {
		Irssi::print("Usage: be looking at the channel you want to spam then: /atg");
	}
}

sub cmd_disable_atg {
  Irssi::print("Killing atg.");
  $thr->kill('KILL')->detach();
}

Irssi::command_bind('atg',      'cmd_atg');
Irssi::command_bind('kill_atg', 'cmd_disable_atg');
