### From multi to single fast5 files

https://github.com/nanoporetech/ont_fast5_api

```
multi_to_single_fast5 -i ~/testing/scrappy/data/fast5/109-21CAG-1_1ratio/ -s /lustrehome/gianluca/testing/scrappy/data/single_fast5
```
### Basecalling, from fast5 to fasta (SCRAPPY python version)  
 
https://github.com/nanoporetech/scrappie

```
scrappy /lustrehome/gianluca/testing/scrappy/data/single_fast5/0/346921ca-82a2-470c-bbf2-90b4bd358aa6.fast5 rgrgr_r94 > ~/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fa
```

### Convert fasta into fastq (perl script) - not necessary

https://code.google.com/archive/p/fasta-to-fastq/

```
perl ~/src/fasta_to_fastq.pl ~/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fa > ~/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fq
```

### Read-to-read overlap finding (conda)

https://github.com/lh3/minimap2

1) indexing reference fasta

```
minimap2 -d ~/testing/minimap2/htt_exon1.mmi ~/testing/reference/htt_exon1_pcr_amplicon.fa
```
2) Alignment 

```
minimap2 -y -a -x map-ont -t 2 --MD ~/testing/minimap2/htt_exon1.mmi ~/testing/scrappy/prova_multi.fq > ~/testing/minimap2/prova2_multi_alignment.sam
```

### Assembly (conda)

https://github.com/marbl/canu

### BWA-MEM , minimap2


### nanopolish
