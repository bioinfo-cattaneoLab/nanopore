
 #Cas9 Targeted Sequencing HTT

```
samtools faidx GCA_000001405.15_GRCh38_no_alt_analysis_set.fna

minimap2 -I 16G -x map-ont --MD -d GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.mmi GCA_000001405.15_GRCh38_no_alt_analysis_set.fna

minimap2 -x map-ont --MD -t 4 -a GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.mmi ../analysis/input.fastq > ../analysis/alignment.bam

bgzip -c alignments.bam > alignments.bam.gz

samtools sort alignments.bam.gz > alignments.sort.bam.gz

mv alignments.sort.bam.gz alignments.bam

samtools index -b alignments.bam
```
