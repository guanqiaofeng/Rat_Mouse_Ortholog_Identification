#!/usr/bin/perl

## clean rat fasta ##

%hash = ();

open FH, "<Rattus_norvegicus_UniProt_MoTrPAC_2017-10-20.fasta";
open OUT, ">Rattus_norvegicus.fasta";
$n = 0;
$m = 0;

while (<FH>)
{
    $seq = $_;
    chomp $seq;
    $m = $m + 1;
    if (/^>[^\|]+\|[^\|]+\|(\S+)/)
    {
	$name = $1;
	if (!(exists ($hash{$name})))
	{
	    if ($seq =~ m/Rattus norvegicus/)
	    {
		if ($m == 1)
		{
		    print OUT ">$name\n";
		}
		else
		{
		    print OUT "\n>$name\n";
		}
		$n = 1;
	    }
	    else
	    {
		$n = 0;
	    }
	    $hash{$name} = 0;
	}
	else
	{
	    $n = 0;
	}
    }
    elsif ($n == 1)
    {
	print OUT "$seq";
    }
}
print OUT "\n";

close FH;
close OUT;

## clean mouse fasta ##

open FH, "<M_musculus_Uniprot_SPROT_2017-04-12.fasta";
open OUT, ">Mus_musculus.fasta";

$m = 0;

while (<FH>)
{
    $seq = $_;
    chomp $seq;
    print "$seq\n";
    $m = $m + 1;
    if (/^(>\S+)/)
    {
	$name = $1;
	if ($m == 1)
	{
	    print OUT "$name\n";
	}
	else
	{
	    print OUT "\n$name\n";
	}
    }
    elsif (/(\S+)/)
    {
	$seqs = $1;
	print OUT "$seqs";
    }
}
print OUT "\n";
close FH;
close OUT;
