# AC2020_Nanopore_PCR6_ha_pcr_flg Nanopore HTT Analysis

## Index Fast5
```
condor_submit -name ettore /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/condor-striqueIndex_c15_p52.job

condor_submit -name ettore /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/condor-striqueIndex_c15_p70.job

condor_submit -name ettore /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/condor-striqueIndex_45Qc21_p61.job
```

## Basecalling
```
for n in 7 10 13; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_basecaller_c15_p52.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_basecaller_c15_p52.qscore$n.err -v qscore="$n" -N guppyCall_c15_p52.qscore$n /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_basecaller_qscore_c15_p52.sh ; done  | less -S
```

## Alignment

```
#### passaggio 52
for n in 7 10 13; do echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_c15_p52.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_c15_p52.qscore$n.err -v qscore="$n" -N guppyAlign_c15_p52.qscore$n /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_aligner_qscore_c15_p52.sh ; done

#### passaggio 70
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_c15_p70.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_c15_p70.qscore10.err -v qscore="$n" -N guppyAlign_c15_p70.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_aligner_qscore_c15_p70.sh

#### passaggio 70 NEO
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_c15_p70.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_c15_p70.qscore10.err -v qscore="$n" -N guppyAlignNEO_c15_p70.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_alignerNEO_qscore_c15_p70.sh

#### passaggio 45Qc21_p61
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_45Qc21_p61.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_45Qc21_p61.qscore10.err -v qscore="$n" -N guppyAlign_45Qc21_p61.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_aligner_qscore_45Qc21_p61.sh

#### passaggio 45Qc21_p61 NEO
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_45Qc21_p61.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_45Qc21_p61.qscore10.err -v qscore="$n" -N guppyAlignNEO_45Qc21_p61.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_alignerNEO_qscore_45Qc21_p61.sh

#### passaggio 45Qc21_p61 CRE
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_45Qc21_p61.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_45Qc21_p61.qscore10.err -v qscore="$n" -N guppyAlignCRE_45Qc21_p61.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_alignerCRE_qscore_45Qc21_p61.sh
```

```
#### allineamento neomicina
/lustrehome/gianluca/src/ont-guppy-cpu/bin/./guppy_aligner -t 10 -i /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p52/20201123_1256_MN29119_AEJ837_8d239393/new_basecalling/guppy_qscore_10/pass/ -s /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p52/20201123_1256_MN29119_AEJ837_8d239393/new_basecalling/guppy_qscore_10/alignment_neo/ --align_ref /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/reference/Promoter_Neo_Fasta.fa
```

minimap2 -t 8 -a /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/reference/barcode029_50Q.fa /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p70/20201207_1247_MN29119_AFI225_9375cada/fastq_pass/all_pass.fastq -o /lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p70/20201207_1247_MN29119_AFI225_9375cada/alignment_barcode/test.sam

```
#### allineamento barcode
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerBarcode_c15_p70.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerBarcode_c15_p70.qscore10.err -v qscore="$n" -N guppyAlignBar_c15_p70.qscore10 /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-guppy_alignerBarcode_qscore_c15_p70.sh
```

## STRique analysis

c15_p52
```
#### passaggio 52
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_c15-p52_150_600bp_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_c15-p52_150_600bp_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p52/20201123_1256_MN29119_AEJ837_8d239393/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p52/20201123_1256_MN29119_AEJ837_8d239393/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/AC2020_Nanopore_PCR6_ha_pcr_flg/HTT_config_AC_PCR6_c15_p52_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p52_qscore$n.150_600bp_CAG.tsv" -N c15_p52.qscore$n.count /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-striqueCount.job ; done

#### passaggio 70
echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_c15-p70_150_600bp_qscore10.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_c15-p70_150_600bp_qscore10.err -v sam="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p70/20201207_1247_MN29119_AFI225_9375cada/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/c15_p70/20201207_1247_MN29119_AFI225_9375cada/fast5_pass/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/AC2020_Nanopore_PCR6_ha_pcr_flg/HTT_config_AC_PCR6_c15_p52_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p70_qscore10.150_600bp_CAG.tsv" -N c15_p70.qscore10.count /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-striqueCount.job
```

## Analysis on Alignment summary : p52 and p70

## STRique count Analysis

```
Rscript /Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/strique_analysis_p62-70.R
```

## Alignment analysis

```
Rscript /Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plot_summary_p62-70.R
```



```
split -l 5000 all_fastq.sam split_fastq_
```

Run STRique with splitted fastq

cat all_fastq.sam | grep -w "SN:Targeting" > header.txt
for n in b c d e f g h i j k l m n o p q r s t u  ; do cat header.txt split_fastq_a$n > split_fastq_$n; done
mv split_fastq_aa split_fastq_a
for n in b c d e f g h i j k l m n o p q r s t u  ; do rm split_fastq_a$n ; done
rm header.txt


for n in 10 ; do for s in a b c d e f g h i j k l m n o p q r s t u; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_45Qc21_p61.$s.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_45Qc21_p61.$s.qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/45Qc21_p61/20210205_1651_MN29119_AFH555_7b988aee/alignment/split_fastq_$s",fofn="/lustre/home/enza/cattaneo/data/AC2020_Nanopore_PCR6_ha_pcr_flg/45Qc21_p61/20210205_1651_MN29119_AFH555_7b988aee/fast5_pass/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/AC2020_Nanopore_PCR6_ha_pcr_flg/HTT_config_AC_PCR6_c15_p52_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_45Qc21_p61.qscore10.150_600bp_CAG.$s.tsv" -N $s.45Q.qs$n.count /lustrehome/gianluca/strique/jobs/AC2020_Nanopore_PCR6_ha_pcr_flg/pbs-striqueCount.job ; done ; done | less -S
