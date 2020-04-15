#!/usr/bin/perl

@filearray = glob("*_genes.txt");

for $input(@filearray)
{
    $output = $input;
    $output =~ s/genes/aln/;
    system("muscle -in $input -out OUT/$output");
}

