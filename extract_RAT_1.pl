#!/usr/bin/perl

%hash = ();

open FH, "<E_cig_global_pep_norm_log2FC_annotated_with_Cys_sites.csv";
open OUT, ">E_cig_global_pep_norm_log2FC_annotated_with_Cys_sites_names.txt";
while (<FH>)
{
    if (/^([^,]+)/)
    {
	$name = $1;
	$hash{$name} = 0;
	print OUT "$name\n";
    }
}
close FH;

open FH, "<Rattus_norvegicus.fasta";
open OUT, ">Rattus_norvegicus_extract.fasta";
$m = 0;
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    if (/^>(\S+)/)
    {
	$seqname = $1;
	if (exists ($hash{$seqname}))
	{
	    print OUT ">$seqname\n";
	    $m = 1;
	}
    }
    elsif ($m == 1)
    {
	print OUT "$seq\n";
	$m = 0;
    }
}
close FH;
close OUT;
