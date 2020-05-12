# Assembly from raw signals data

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6781587/

### From multi to single fast5 files

* https://github.com/nanoporetech/ont_fast5_api
* https://anaconda.org/bioconda/ont-fast5-api <-

```
/lustrehome/gianluca/src/anaconda3/bin/multi_to_single_fast5 -i /lustrehome/gianluca/testing/scrappy/data/fast5/109-21CAG-1_1ratio/ -s /lustrehome/gianluca/testing/scrappy/data/single_fast5
```
### Basecalling, from fast5 to fasta   

https://github.com/nanoporetech/scrappie (scrappy, python version)

```
/lustrehome/gianluca/src/anaconda3/bin/./scrappy /lustrehome/gianluca/testing/scrappy/data/single_fast5/0/346921ca-82a2-470c-bbf2-90b4bd358aa6.fast5 rgrgr_r94 > /lustrehome/gianluca/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fa
```

### Convert fasta into fastq - not necessary

https://code.google.com/archive/p/fasta-to-fastq/

```
perl /lustrehome/gianluca/src/fasta_to_fastq.pl /lustrehome/gianluca/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fa > /lustrehome/gianluca/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fq
```

### Read-to-read overlap finding

* https://github.com/lh3/minimap2
* https://anaconda.org/bioconda/minimap2 <-

1) Indexing reference fasta

```
/lustrehome/gianluca/src/anaconda3/bin/./minimap2 -d /lustrehome/gianluca/testing/minimap2/htt_exon1.mmi /lustrehome/gianluca/testing/reference/htt_exon1_pcr_amplicon.fa
```
2) Alignment

```
/lustrehome/gianluca/src/anaconda3/bin/./minimap2 -y -a -x map-ont -t 2 --MD /lustrehome/gianluca/testing/minimap2/htt_exon1.mmi /lustrehome/gianluca/testing/scrappy/prova_multi.fq > /lustrehome/gianluca/testing/minimap2/sam/multi_alignment_0.sam
```

### Assembly

* https://github.com/marbl/canu
* https://github.com/marbl/canu/releases/download/v2.0/canu-2.0.Linux-amd64.tar.xz <-

```
/lustrehome/gianluca/src/canu-2.0/Linux-amd64/bin/canu -p htt -d /lustrehome/gianluca/testing/canu/htt_0_2.3k genomeSize=2.3k useGrid=false -nanopore /lustrehome/gianluca/testing/scrappy/fasta/multi_0.fa
```

### Read Mapping

https://anaconda.org/bioconda/bwa

```
/lustrehome/gianluca/src/anaconda3/bin/./bwa index /lustrehome/gianluca/testing/canu/htt_0_2.3k/htt.contigs.fasta

/lustrehome/gianluca/src/anaconda3/bin/./bwa mem -x ont2d -t 2 /lustrehome/gianluca/testing/canu/htt_0_2.3k/htt.contigs.fasta /lustrehome/gianluca/testing/scrappy/fasta/multi_0.fa > /lustrehome/gianluca/testing/bwa/sam/multi_0.sam
```
Transform SAM into BAM
```
/lustrehome/enza/bin/samtools-1.9/samtools view -b -S /lustrehome/gianluca/testing/bwa/sam/multi_0.sam > /lustrehome/gianluca/testing/bwa/bam/multi_0.bam

/lustrehome/enza/bin/samtools-1.9/samtools sort /lustrehome/gianluca/testing/bwa/bam/multi_0.bam > /lustrehome/gianluca/testing/bwa/bam/multi_0_sorted.bam

/lustrehome/enza/bin/samtools-1.9/samtools index /lustrehome/gianluca/testing/bwa/bam/multi_0_sorted.bam
```

### Polishing

https://github.com/jts/nanopolish

1) Obtain the range
```
python /lustrehome/gianluca/src/nanopolish/scripts/nanopolish_makerange.py /lustrehome/gianluca/testing/canu/htt_0_2.3k/htt.contigs.fasta > range.txt
```

2) Indexing of raw data
```
/lustrehome/gianluca/src/nanopolish/./nanopolish index -d /lustrehome/gianluca/testing/scrappy/data/fast5/109-21CAG-1_1ratio/ /lustrehome/gianluca/testing/scrappy/fasta/multi_0.fa
```
3) Polishing
```
/lustrehome/gianluca/src/nanopolish/./nanopolish variants -consensus -w tig00000002:0-2399 -p 2 -t 2 -r /lustrehome/gianluca/testing/scrappy/fasta/multi_0.fa -b /lustrehome/gianluca/testing/bwa/bam/multi_0_sorted.bam -g /lustrehome/gianluca/testing/canu/htt_0_2.3k/htt.contigs.fast
```
