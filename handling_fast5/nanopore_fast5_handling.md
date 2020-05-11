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

1) Indexing reference fasta

```
minimap2 -d ~/testing/minimap2/htt_exon1.mmi ~/testing/reference/htt_exon1_pcr_amplicon.fa
```
2) Alignment

```
minimap2 -y -a -x map-ont -t 2 --MD ~/testing/minimap2/htt_exon1.mmi ~/testing/scrappy/prova_multi.fq > ~/testing/minimap2/prova2_multi_alignment.sam
```

### Assembly (preCompiled by GitHub)

* https://github.com/marbl/canu
* https://github.com/marbl/canu/releases/download/v2.0/canu-2.0.Linux-amd64.tar.xz

```
~/src/canu-2.0/Linux-amd64/bin/canu -p htt -d ~/testing/canu/htt_0_2.3k genomeSize=2.3k useGrid=false -nanopore ~/testing/scrappy/fasta/multi_0.fa
```

### BWA-MEM , minimap2

https://anaconda.org/bioconda/bwa

```
bwa index ~/testing/canu/htt_0_2.3k/htt.contigs.fasta

bwa mem -x ont2d -t 2 ~/testing/canu/htt_0_2.3k/htt.contigs.fasta ~/testing/scrappy/fasta/multi_0.fa > ~/testing/bwa/multi_0.sam
```
Transform SAM into BAM
```
/lustrehome/enza/bin/samtools-1.9/samtools view -b -S ~/testing/bwa/multi_0.sam > ~/testing/bwa/multi_0.bam

/lustrehome/enza/bin/samtools-1.9/samtools sort ~/testing/bwa/multi_0.bam > ~/testing/bwa/multi_0_sorted.bam

/lustrehome/enza/bin/samtools-1.9/samtools index ~/testing/bwa/multi_0_sorted.bam
```

### Nanopolish

https://github.com/jts/nanopolish

1) Obtain the range
```
python ~/src/nanopolish/scripts/nanopolish_makerange.py ~/testing/canu/htt_0_2.3k/htt.contigs.fasta > range.txt
```

2) Indexing of raw data
```
~/src/nanopolish/./nanopolish index -d ~/testing/scrappy/data/fast5/109-21CAG-1_1ratio/ ~/testing/scrappy/fasta/multi_0.fa
```
3) Polishing
```
~/src/nanopolish/./nanopolish variants -consensus -w tig00000002:0-2399 -p 2 -t 2 -r ~/testing/scrappy/fasta/multi_0.fa -b ~/testing/bwa/multi_0_sorted.bam -g ~/testing/canu/htt_0_2.3k/htt.contigs.fast
```
