#!/usr/bin/perl

use strict;
use LWP::Simple;


open IN, "</home/sgy/Dropbox/Vargo/data/Maddresses.csv" or die $!;
open OUT, ">./data/results.csv" or die $!;

my $i = 0;

while (my $address = <IN>) {
    if ( $i != 0 ){

	print $i, " of 160852", "\t", $address;
	chomp $address;
	my ($number, $direction, $streetname, $streettype, $unit, $city ) = split /,/, $address;

	my $url = "http://www.mge.com/customer-service/home/average-use-cost/results.htm?hn=$number&sd=$direction&sn=$streetname&ss=$streettype&au=$unit&c=$city";

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

	# print $address, ",", $data[0], ",", $data[1], ",", $data[2], "\n";
	print OUT $address, ",", $data[0], ",", $data[1], ",", $data[2], "\n";

	$i++;

    }else{

	$i++;

    }
    
}

close IN;
close OUT;
