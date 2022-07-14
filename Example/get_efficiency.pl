#!user/bin/perl -w
use strict;
use warnings;

unless(@ARGV==3){
	die "USAGE: This program calcuates the efficiency and EDR for the network without nodes.\nperl $0 <shortest.path.csv> <MIS.xls> <efficiency.xls>!\n";
}

my(%nodes, $n);

#Get the names of nodes
open IN, "$ARGV[1]"||die $!;
<IN>;
while(<IN>){
	chomp(my $line=$_);
	my @array=split /\s+/, $line;
	$nodes{$array[0]}=1;
	$n++;
}
close IN;

#Calculate the efficiency for the whole network
open OUT,">$ARGV[2]" || die $!;
print OUT "Node\tEfficiency\tEDR\n";

open IN3, "$ARGV[0]" || die $!;
<IN3>;
my ($a_edge, $a_efficiency);
while(<IN3>){
        my ($edge, $efficiency);
        chomp(my $line=$_);
        $line=~s/"//g;
        my @array=split /\,/, $line;
        if ($array[3] == 0){
                next;
        }else{
                $a_edge += 1/$array[3];
        }
}
close IN3;
$a_efficiency = $a_edge/$n/($n-1);
print OUT "All\t$a_efficiency\t0\n";

#Calculate the efficiency and EDR (Efficiency Decreasing Ratio) for the network without each node
for $a (sort keys %nodes){
	my ($edge, $efficiency, $EDR);
	open IN2, "$ARGV[0]" || die $!;
	<IN2>;
	while(<IN2>){
		chomp(my $line=$_);
		$line=~s/"//g;
		my @array=split /\,/, $line;
		if ($array[3] == 0 || $array[1] eq $a || $array[2] eq $a){
			next;
		}else{
			$edge += 1/$array[3];
		}
	}
	close IN2;
	$efficiency = $edge/($n-1)/($n-2);
	$EDR = ($a_efficiency-$efficiency)/$a_efficiency;
	print OUT "$a\t$efficiency\t$EDR\n";
}

close OUT;
