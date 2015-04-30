#!/usr/bin/perl

use strict;
use LWP::Simple;


open IN, "</home/sgy/Dropbox/Vargo/data/Maddresses.csv" or die $!;
open OUT, ">/home/sgy/Dropbox/Vargo/data/results.csv" or die $!;

# open IN, "</home/sgy/Dropbox/Vargo/data/Maddresses-test.csv" or die $!;
# open OUT, ">/home/sgy/Dropbox/Vargo/data/results-test.csv" or die $!;

print OUT "vargo.ID,hn,sd,sn,ss,au,c,therms.high,therms.cost.high,therms.days.high,therms.low,therms.cost.low,therms.days.low,therms.average,therms.cost.average,kWh.high,kWh.cost.high,kWh.days.high,kWh.low,kWh.cost.low,kWh.days.low,kWh.average,kWh.cost.average\n";

my $i = 0;

while (my $address = <IN>) {
    if ( $i != 0 ){

	print $i, " of 160852", "\t", $address;
	chomp $address;
	my ($number, $direction, $streetname, $streettype, $unit, $city ) = split /,/, $address;

	my $url = "http://www.mge.com/customer-service/home/average-use-cost/results.htm?hn=$number&sd=$direction&sn=$streetname&ss=$streettype&au=$unit&c=$city";

	my $filename = "./data/results.html";

	my $rc = getstore($url, $filename);

	# if (is_error($rc)) {
	#     die "getstore of <$url> failed with $rc";
	# }

	open HTML, "<$filename" or die $!;

	my @data;

	while (my $line = <HTML>) {
	    if( $line =~ m/kWh/) {
		if( $line =~ m/>(\d*)\&nbsp/){
		    push(@data, $1);
		}
	    }

	    if( $line =~ m/therms/) {
		if( $line =~ m/>(\d*)\&nbsp/){
		    push(@data, $1);
		}
	    }

	    if( $line =~ m/days/) {
		if( $line =~ m/>(\d*)\ /){
		    push(@data, $1);
		}
	    }

	    if( $line =~ m/\>\$(\d*)\</) {
		if( $line =~ m/>\$(\d*)\</){
		    push(@data, $1);
		}
	    }

	}


	close HTML;

	print OUT $address, ",", $data[0], ",", $data[1], ",", $data[2], ",", $data[3], ",", $data[4], ",", $data[5], ",", $data[6], ",", $data[7], ",", $data[8], ",", $data[9], ",", $data[10], ",", $data[11], ",", $data[12], ",", $data[13], ",", $data[14], ",", $data[15], "\n";

	$i++;

    }else{

	$i++;

    }
    
}

close IN;
close OUT;
