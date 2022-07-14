#!user/bin/perl -w
use strict;
use warnings;

unless(@ARGV==4){
	die "USAGE: This program calculates the MIS (abundance-weighted Mean Interaction Strength) for all nodes in the specific network.\nperl $0 <mean_abundece.csv> <correlation.matrix.csv> <AD or WT> <MIS.results>\!\n";
}

chomp(my $target =$ARGV[2]);

my (%abun, %relation, %taxo);

#Get the mean abundance for the nodes
open IN1, "$ARGV[0]"||die $!;
<IN1>;
while (<IN1>){
	chomp(my $line=$_);
	$line=~s/\"//g;
	my @array=split /\,/, $line;
	if ($array[1] eq $target){
		$abun{$array[2]}=$array[3];
	}
}
close IN1;

#Get the relations among the nodes
open IN2, "$ARGV[1]"||die $!;
chomp(my $header=<IN2>);
$header=~s/\"//g;
my @header=split /\,/, $header;
while(<IN2>){
	chomp(my $line=$_);
	$line=~s/\"//g;
	my @array=split /\,/, $line;
	for my $a (1..$#array){
		if ($array[$a] != 0){
			$relation{$array[0]}{$header[$a]}= abs ($array[$a]);
			$relation{$header[$a]}{$array[0]}= abs ($array[$a]);
		}
	}
	$taxo{$array[0]}=1;
}
close IN2;

#Calculate the MIS for all nodes
open OUT,">$ARGV[3]"||die $!;
print OUT "Taxo\tMIS\n";
for my $x (sort keys %taxo){
	my ($total_relation, $total_abun_x_relation, $MIS);
	for my $y (sort keys %taxo){
		if ($x ne $y && exists $relation{$x}{$y}){
			$total_relation += $relation{$x}{$y};
			$total_abun_x_relation += $abun{$y}*$relation{$x}{$y};
			#print "$x\t$y\t$relation{$x}{$y}\n";
		}
	}
	if ($total_relation >0){
		$MIS = $total_abun_x_relation/$total_relation;
		print OUT "$x\t$MIS\n";
	}
}
close OUT;
