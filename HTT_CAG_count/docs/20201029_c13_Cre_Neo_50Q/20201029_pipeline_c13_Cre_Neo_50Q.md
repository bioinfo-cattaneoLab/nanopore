# 20201310 Nanopore HTT Analysis

## Index Fast5
```
condor_submit -name ettore /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/condor-striqueIndex_50Q-p67.job

condor_submit -name ettore /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/condor-striqueIndex_50Q-p52.job
```


## Basecalling
```

for c in 52 67 ; do for n in 7 10 13; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_basecaller_50Q-p$c.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_basecaller_50Q-p$c.qscore$n.err -v qscore="$n" -N guppyCall_50Q-p$c.qscore$n /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/pbs-guppy_basecaller_qscore_50Q-p$c.sh ; done ; done | less -S
```

## Alignment

```
for c in 52 67 ; do for n in 7 10 13; do echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_50Q-p$c.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_50Q-p$c.qscore$n.err -v qscore="$n" -N guppyAlign_50Q-p$c.qscore$n /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/pbs-guppy_aligner_qscore_50Q-p$c.sh ; done ; done
```

## STRique analysis

50Q-p52
```
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_50Q-p52_150_600bp_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_50Q-p52_150_600bp_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/PCR/c13_Cre_Neo_50Q_p52/20201029_1636_MN29119_AEJ563_7db1a372/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/PCR/c13_Cre_Neo_50Q_p52/20201029_1636_MN29119_AEJ563_7db1a372/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201029_c13_Cre_Neo_50Q/HTT_config_20201029_c13_Cre_Neo_50Q_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201029_c13_Cre_Neo_50Q/20201029_allSAM_qscore$n.50Q-p52.150_600bp_CAG.tsv" -N p52.qscore$n.count /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/pbs-striqueCount.job ; done
```
50Q-p67
```
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_50Q-p67_150_600bp_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_50Q-p67_150_600bp_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/PCR/c13_Cre_Neo_50Q_p67/20201030_1517_MN29119_AEJ837_5484a711/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/PCR/c13_Cre_Neo_50Q_p67/20201030_1517_MN29119_AEJ837_5484a711/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201029_c13_Cre_Neo_50Q/HTT_config_20201029_c13_Cre_Neo_50Q_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201029_c13_Cre_Neo_50Q/20201029_allSAM_qscore$n.50Q-p67.150_600bp_CAG.tsv" -N p67.qscore$n.count /lustrehome/gianluca/strique/jobs/20201029_c13_Cre_Neo_50Q/pbs-striqueCount.job ; done
```






## STRique analysis

Split all_fastq.sam into file with 20k rows (reads)

```
split -l 20000 all_fastq.sam split_fastq_
```

Add header at each splitted file
```
cat all_fastq.sam | grep -w "SN:HDR" > header_fastq.txt
for n in b c d e f ; do cat header_fastq.txt split_fastq_a$n > split_fastq_$n; done
mv split_fastq_aa split_fastq_a
for n in b c d e f ; do rm split_fastq_a$n ; done
rm header_fastq.txt
```

Run STRique with splitted fastq
```
for n in 7 ; do for s in a b c d e f ; do for c in 1000bp full ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_150.$c.rep3.$s.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_150.$c.rep3.$s.qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/guppy_qscore_$n/alignment/split_fastq_$s",fofn="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201013/HTT_config_20201013_150.$c.CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201013/20201013_qscore$n.rep3.$s.150.$c.CAG.tsv" -N $s.rep3.qs$n.$c.count ~/strique/jobs/20201013/pbs-striqueCount.job ; done ; done ; done | less -S

```
###### testing

STRique count with different config file for different qscore
```
for n in 7; do for s in a b c d e f ; do for c in 1000bp full ; do echo condor_submit -name ettore -a "sam=/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/guppy_qscore_$n/alignment/split_fastq_$s" -a "fofn=/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/all_fast5/reads.fofn" -a "config=/lustre/home/enza/cattaneo/config_file/20201013/HTT_config_20201013_150.$c.CAG.tsv" -a "output=/lustrehome/gianluca/strique/striqueOutput/20201013/20201013_qscore$n.rep3.$s.150.$c.CAG.tsv" -a "n=$s.rep3.qs$n.$c.count" ~/strique/jobs/20201013/condor-striqueCount_exp.job ; done; done; done
```


#########################################################################


STRique count with different config file for different qscore

Replicate 1
```
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep1_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep1_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO/20201008_1459_MN29119_AEG347_6fcabde8/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO/20201008_1459_MN29119_AEG347_6fcabde8/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201013/HTT_config_20201013_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201013/20201013_allSAM_qscore$n.rep1.150_600bp_CAG.tsv" -N rep1.qscore$n.count ~/strique/jobs/20201013/pbs-striqueCount.job ; done
```

Replicate 2
```
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep2_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep2_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-2/20201009_1401_MN29119_AEG629_295f13f5/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-2/20201009_1401_MN29119_AEG629_295f13f5/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201013/HTT_config_20201013_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201013/20201013_allSAM_qscore$n.rep2.150_600bp_CAG.tsv" -N rep2.qscore$n.count ~/strique/jobs/20201013/pbs-striqueCount.job ; done
```

Replicate 3
```
for n in 7 10 13 ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep3_qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_150_600bp_rep3_qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/guppy_qscore_$n/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/20201013_plasmidReplicate/21Q-CRE-NEO-3/20201012_1443_MN29119_AEG753_c2aa6956/new_basecalling/all_fast5/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/20201013/HTT_config_20201013_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/20201013/20201013_allSAM_qscore$n.rep3.150_600bp_CAG.tsv" -N rep3.qscore$n.count ~/strique/jobs/20201013/pbs-striqueCount.job ; done
```
### [R analysis]() of STRique OUTPUT

```
Rscript ~/projects/cattaneo/debug/count_CAG_allQscore.R
```

## DEBUG

### Debug Alignment

```
Rscript ~/projects/cattaneo/debug/plot_summaryAlignment.R
```

info from Fast5
```
# number of fast5 reads

cat /lustre/home/enza/cattaneo/data/20200813_1444_MN29119_AEG653_694c71a4/new_basecalling/all_fast5/reads.fofn | wc -l
```
info from fastq reads with qscore > THRESHOLD (PASS)
```
# number of pass reads

cat /lustre/home/enza/cattaneo/data/20200813_1444_MN29119_AEG653_694c71a4/new_basecalling/guppy_qscore_7/pass/fastq_runid_ab4c51e370a39025bfacdeabffb0e2d16507f36b_* | grep sampleid | wc -l
```
info from fastq reads with qscore < THRESHOLD (FAIL)

```
# number of fail reads

cat /lustre/home/enza/cattaneo/data/20200813_1444_MN29119_AEG653_694c71a4/new_basecalling/guppy_qscore_7/fail/fastq_runid_ab4c51e370a39025bfacdeabffb0e2d16507f36b_* | grep sampleid | wc -l
```
info from SAM
```
# number of sam reads

cat /lustre/home/enza/cattaneo/data/20200813_1444_MN29119_AEG653_694c71a4/new_basecalling/guppy_qscore_7/alignment/fastq_runid_ab4c51e370a39025bfacdeabffb0e2d16507f36b_* | grep -v @ | cut -f 1 | sort | uniq | wc -l
```
info from different STRique's debug_logs
```
# Loop for all info

for t in 150_CAG 150_600bp_CAG 150_1000bp_CAG 200_CAG 200_600bp_CAG 200_1000bp_CAG ; do for c in No Test Err ; do cat $t.qscore7.count.err  | cut -f 4 -d ":" | grep $c | tr " " "\t" | cut -f 5 | wc -l ; done ; done
```
### [R analysis]() for debugging using all different combination of prefix/suffix length, Ref-Interval and info about basecalling and debug_log from STRique.

```
Rscript /Users/gianlucadamaggio/projects/cattaneo/debug/plot-debug.R
```

### Merge summary file from basecalling with debug_log from STRique

#### Info from STRique's debug_log

reads with no target for config file
```
cat qscore_7.count.err | cut -f 4 -d ":" | grep "No" | tr " " "\t" |cut -f 5 | wc -l
```
Error parsing alignment
```
cat qscore_7.count.err | cut -f 4 -d ":" | grep "Err" | tr " " "\t" |cut -f 5 | wc -l
```
Tested for targets
```
cat qscore_7.count.err | cut -f 4 -d ":" | grep "Test" | tr " " "\t" |cut -f 5 | wc -l
```
list of unique IDs
```
cat qscore_7.count.err | cut -f 4 -d ":" | grep "No" | tr " " "\t" |cut -f 5 | sort | uniq  > uniq_id.txt
```
list of reads used by strique
```
cat qscore_7.count.err | cut -f 4 -d ":" | grep "Test" | tr " " "\t"|cut -f 3 > good_reads.txt
```
#### [R analysis]() after obtain reads used by STRique (good_reads)
```
Rscript ~/projects/cattaneo/debug/tested4targetsXsummaryAlign.R
```
