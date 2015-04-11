#!/usr/bin/perl

use strict;
use LWP::Simple;

my $number = 514;
my $direction = "S";
my $streetname = "Baldwin";
my $streettype = "St";
my $city = "Madison";

## my $url = "http://www.mge.com/customer-service/home/average-use-cost/results.htm?hn=314&sd=N&sn=Blount&ss=St&au=&c=Madison";

my $url = "http://www.mge.com/customer-service/home/average-use-cost/results.htm?hn=$number&sd=$direction&sn=$streetname&ss=$streettype&au=&c=$city";

my $filename = "./data/results.html";

my $rc = getstore($url, $filename);

if (is_error($rc)) {
	die "getstore of <$url> failed with $rc";
}

open HTML, "<$filename" or die $!;

my @data;

while (my $line = <HTML>) {
    if( $line =~ m/kWh/) {
	if( $line =~ m/>(\d*)\&nbsp/){
	    push(@data, $1);
	}
    }
}

close HTML;

print "High: $data[0]\nLow: $data[1]\nAverage: $data[2]\n";
