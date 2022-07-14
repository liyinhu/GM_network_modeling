#!usr/bin/perl -w
#use strict;
use warnings;

unless(@ARGV==3){
	die "USAGE: This program evaluates the Robustness for a network through simulations of Random-Attack or Target-Removal.\nperl $0 <MIS.xls> <Hub.info> <Robustness.xls>\!\n\nThe format for the Hub.info file:\nFile Type\tPath to file\tRandom select number\n";
}

my (%MIS, $all_MIS, %path, %number);

#Store the MIS for each node
open IN, "$ARGV[0]" || die $!;
<IN>;
while(<IN>){
	chomp(my $line = $_);
	my @array=split /\s+/, $line;
	$MIS{$array[0]}=$array[1];
	$all_MIS += $array[1];
}
close IN;

#Get the node information for random selection
open IN2, "$ARGV[1]" || die $!;
<IN2>;
while(<IN2>){
	chomp(my $line = $_);
	my @array= split /\s+/, $line;
	$path{$array[0]}=$array[1];
	$number{$array[0]}=$array[2];
}
close IN2;

for my $a (sort keys %path){
#	@{$a};
	open IN3, "$path{$a}" || die $!;
	while(<IN3>){
		chomp(my $line = $_);
		push (@{$a},$line);
	}
	close IN3;
}

#Perform Random-Attack and Target-Removal for the network and calculate the Robustness
open OUT, ">$ARGV[2]" || die $!;
print OUT "Type\tMIS_ratio\tRemoved_nodes\n";

for my $b (sort keys %path){
	for my $x (1..10){
		my $pick_left = $number{$b};
		my @raw = @{$b};
		my @picks;
		while($pick_left > 0){
			my $rand = int(rand($pick_left))-1 ;
			push @picks, $raw[$rand];
			splice (@raw, $rand, 1);
			$pick_left--;
		}
		my $MIS_left = $all_MIS;
		for my $y (0..$#picks){
			$MIS_left -= $MIS{$picks[$y]};
		}
		my $ratio = $MIS_left/ $all_MIS;
		my $var = join (",", @picks);
		print OUT "$b\t$ratio\t$var\n";
	}
}

close OUT;
