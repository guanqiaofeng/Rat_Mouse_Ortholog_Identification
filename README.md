# Rat_to_Mouse

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

This step blast Rattus_norvegicus_extract.fasta (query) against Mus_musculus.fasta (target) and only keep the best blast hit. Output file is Rat_to_Mouse_noe_list.txt.
```
$ makeblastdb -in Mus_musculus.fasta -dbtype prot -out Mus.db

$ blastp -db Mus.db -query Rattus_norvegicus_extract.fasta -out Rat_to_Mouse_noe.txt -outfmt 6 -max_target_seqs 1

$ cut -f 1,2 Rat_to_Mouse_noe.txt | uniq > Rat_to_Mouse_noe_list.txt

$ wc -l Rat_to_Mouse_noe_list.txt
      # 2824 out of 2825 Rat genes has blast hit.
```
