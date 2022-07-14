#!usr/bin/perl -w
use strict;
use warnings;

unless(@ARGV==3){
	die "USAGE: This program helps to find the common taxo across the timeline.\nperl $0 <mean_abundance.lst> <AD or WT> <Common_tax.output>\!\n";
}

my (%path, $target, %abun, %taxo);

$target = $ARGV[1];

#To get the path for the mean_abundance.file 
open IN, "$ARGV[0]"||die $!;
<IN>;
while(<IN>){
	chomp(my $line=$_);
	my @array=split /\s+/, $line;
	$path{$array[0]}=$array[1];
}
close IN;

#To pileup the mean abundances for the taxo
for my $x (sort keys %path){
	open IN1, "$path{$x}" || die $!;
	<IN1>;
	while(<IN1>){
		chomp(my $line=$_);
		$line=~s/\"//g;
		my @array = split /\,/, $line;
		if ($array[1] eq $target){
			$abun{$array[2]}{$x}=$array[3];
			$taxo{$array[2]}=1;
		}
	}
	close IN1;
}

#To find the common tax
open OUT, ">$ARGV[2]"||die $!;
print OUT "Taxo\t1M_mean\t2M_mean\t3M_mean\t6M_mean\t9M_mean\n";
for my $y (sort keys %taxo){
	my ($out, $num);
	$out = $y;
	for my $z (sort keys %path){
		if (exists $abun{$y}{$z}){ 
			$out .= "\t$abun{$y}{$z}";
		}else {
			$out .= "\t0";
		}
		if (exists $abun{$y}{$z} && $abun{$y}{$z} > 0){
			$num +=1;
		}
	}
	if ($num == 5){
		print OUT "$out\n";
	}
}
close OUT;
