#!/usr/bin/perl

%rat = ();
%mouse = ();

open FH, "<Rattus_norvegicus_extract.fasta";
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    if (/^>(\S+)/)
    {
	$name = $1;
    }
    else
    {
	$rat{$name} = $seq;
    }
}
close FH;

open FH, "<Mus_musculus.fasta";
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    if (/^>(\S+)/)
    {
	$name = $1;
    }
    else
    {
	$mouse{$name} = $seq;
    }
}
close FH;

$m = 0;
open FH, "<Rat_to_Mouse_noe_list.txt";
while (<FH>)
{
    $m = $m + 1;
    if (/(\S+)\s+(\S+)/)
    {
	$rat_gene = $1;
	$mouse_gene = $2;
	open OUT, ">genes/$m_genes.txt";
	print OUT ">$rat_gene\n$rat{$rat_gene}\n";
	print OUT ">$mouse_seq\n$mouse{$mouse_gene}\n";
	close OUT;
    }
}
close FH;
close OUT;

