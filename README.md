# Rat_to_Mouse

Developer: Guanqiao Feng 
2019

Pipeline used in "Wang J*, Zhang T*, Johnston CJ, Kim SY, Gaffrey MJ, Chalupa D, Feng G, Qian WJ, McGraw MD, Ansong C. 2020. Protein thiol oxidation in the rat lung following e-cigarette exposure. Redox biology. 37: 101758."

This pipeline compared cysteine sites identified in rats in the current study with cysteine sites identified in mice from a previous study (Nature Communication 9,2018,1581). These cysteine sites are subjected to oxidation in response to redox stress.

It includes the following steps: data cleaning -> ortholog identification -> sequence alignment -> conserved and unique cysteine site identification.

The study 'covered 6682 unique rat cysteine sites, among which 1805 sites were also characterized in mice.'"

## step 1. clean the fasta files

This step takes input files (Rattus_norvegicus_UniProt_MoTrPAC_2017-10-20.fasta & M_musculus_Uniprot_SPROT_2017-04-12.fasta) and generate output files (Rattus_norvegicus.fasta & Mus_musculus.fasta). It cleans the name, puts sequence into one line, only keeps the first gene if multiple genes with the same name exist in the file (only for Rat file).
```
$ perl clean_fasta_0.pl
```

## step 2. extract Rat genes

This step extracts rat genes (E_cig_global_pep_norm_log2FC_annotated_with_Cys_sites.csv, total of 2825 genes) from input file (Rattus_norvegicus.fasta) and generates output file (Rattus_norvegicus_extract.fasta).
```
$ perl extract_RAT_1.pl
```

## step 3. blast search

This step blasts Rattus_norvegicus_extract.fasta (query) against Mus_musculus.fasta (target) and only keep the best blast hit. Output file is Rat_to_Mouse_noe_list.txt.
```
$ makeblastdb -in Mus_musculus.fasta -dbtype prot -out Mus.db

$ blastp -db Mus.db -query Rattus_norvegicus_extract.fasta -out Rat_to_Mouse_noe.txt -outfmt 6 -max_target_seqs 1

$ cut -f 1,2 Rat_to_Mouse_noe.txt | uniq | sort -k2 > Rat_to_Mouse_noe_list.txt

$ wc -l Rat_to_Mouse_noe_list.txt
      2824
      # 2824 out of 2825 Rat genes have blast hit.
```
The one rat gene which do not have blast hit in mouse database is "A0A0G2K786_RAT".

## step 4. extract ortholog sequences

This step extracts sequences for rat and mouse gene pairs (Rat_to_Mouse_noe_list.txt) from this two files (Rattus_norvegicus_extract.fasta & Mus_musculus.fasta). It generates 2824 files (1_genes.txt, 2_genes.txt...)
```
$ perl find_list_gene.pl
```

## step 5. alignment

This step uses software **muscle v3.8.1551** to do the alignment. It generate 2824 files under OUT/ directory (1_aln.txt, 2_aln.txt...)
```
$ makedir OUT

$ perl muscle.pl
```

## step 6. extract cycteine position information

This step extracts cycteine position form 2824 \*\_aln.txt alignment files and output an excel file "cycteine_pos_summary.txt". Position indicates the position information in the respective protein sequence. 

```
$ perl extract_cycteine.pl

$ head cycteine_pos_summary.txt
Rat_gene	Rat_pos	Mouse_gene	Mouse_pos
1433B_RAT	96	1433B_MOUSE	96
1433B_RAT	191	1433B_MOUSE	191
1433E_RAT	97	1433E_MOUSE	97
1433E_RAT	98	1433E_MOUSE	98
1433E_RAT	192	1433E_MOUSE	192
1433F_RAT	97	1433F_MOUSE	97
1433F_RAT	112	1433F_MOUSE	112
1433F_RAT	194	1433F_MOUSE	194
A0A0G2K2B8_RAT	125	1433F_MOUSE	97

$ cut -f 1 cycteine_pos_summary.txt | sort | uniq | wc -l
      2813
      # 2812 out of 2824 rat genes have cycteine position in ortholog with rat genes.
```
The left 12 rat genes are:

TSPO_RAT, PPIB_RAT, M0RCJ6_RAT, M0RBQ5_RAT, M0R523_RAT, H4_RAT, GSTA4_RAT, F1M0R2_RAT, D3ZE02_RAT, A0A0G2JUA5_RAT, A0A0G2JU96_RAT, A0A0G2JT56_RAT
