#!/usr/bin/perl

open OUT, ">cycteine_pos_summary.txt";
print OUT "Rat_gene\tRat_pos\tMouse_gene\tMouse_pos\n";

for (1..2824)
{
    $j = $_;
    $name = "";
    $name00 = "";

    $seq = "";
    $seq00 = "";
    open FH, "<$j\_aln.txt";
    while (<FH>)
    {
	if (/^>(\S+)/)
	{
	    $name = $1;
	    $name00 = $name00 . ":" . $name;
	}
	elsif (/(\S+)/)
	{
	    $seq = $1;
	    $seq00 = $seq00 . $seq;
	}
    }
    @name00 = split(/:/, $name00);

    $a = 0;
    $b = 0;
    $a_pos = "";
    $b_pos = "";

    $length = length($seq00)/2;
    for (1..$length)
    {
	$i = $_;
	$a_pos = substr($seq00, $i-1, 1);
	$b_pos = substr($seq00, $i+$length-1, 1);
	if ($a_pos ne "-")
	{
	    $a = $a + 1;
	}
	if ($b_pos ne "-")
	{
	    $b = $b + 1;
	}
	if (($a_pos eq "C") && ($b_pos eq "C"))
	{
	print OUT "$name00[1]\t$a\t$name00[2]\t$b\n";
	}
    }
    close FH;
}
close OUT;
