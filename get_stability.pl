#!usr/bin/perl -w
use strict;
use warnings;

unless(@ARGV==3){
	die "USAGE: Using the MIS value and the common taxon, this programe calcualtes the stability of the network across timeline.\nperl $0 <MIS.lst> <common_tax.xls> <stabliity.xls>\!\n";
}

my (%common_tax, %MIS_path);

#Store the common taxo
open IN, "$ARGV[1]" || die $!;
<IN>;
while (<IN>){
	chomp(my $line=$_);
	my @array=split /\s+/, $line;
	$common_tax{$array[0]}=1;
}
close IN;

#Store the path for the MIS files
open IN, "$ARGV[0]" || die $1;
<IN>;
while (<IN>){
	chomp(my $line = $_);
	my @array = split /\s+/, $line;
	$MIS_path{$array[0]}=$array[1];
}
close IN;

#Calculate the stability for the networks
open OUT, ">$ARGV[2]" || die $!;
print OUT "Time\tStability\n";
for my $x (sort keys %MIS_path){
	open IN1, "$MIS_path{$x}" || die $!;
	<IN1>;
	my ($target, $all, $stability);
	while (<IN1>){
		chomp( my $line=$_);
		my @array = split /\s+/, $line;
		$all += $array[1];
		if (exists $common_tax{$array[0]}){
			$target += $array[1];
		}
	}
	$stability = $target / $all;
	print OUT "$x\t$stability\n";
	close IN1;
}
close OUT;

