# AC2020_Nanopore_PCR6_ha_pcr_flg Nanopore HTT Analysis

## Index Fast5
```
condor_submit -name ettore /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/condor-striqueIndex_81Q-50Q.job

```

## Alignment

```
#### passaggio 50Q-80Q
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_81Q-50Q.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_aligner_81Q-50Q.qscore10.err -v qscore="$n" -N guppyAlign_81Q-50Q.qscore10 /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/pbs-guppy_aligner_qscore_81Q-50Q.sh

#### passaggio 50Q-80Q NEO
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_81Q-50Q.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_81Q-50Q.qscore10.err -v qscore="$n" -N guppyAlignNEO_81Q-50Q.qscore10 /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/pbs-guppy_alignerNEO_qscore_81Q-50Q.sh

#### passaggio 50Q-80Q CRE
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_81Q-50Q.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_81Q-50Q.qscore10.err -v qscore="$n" -N guppyAlignCRE_81Q-50Q.qscore10 /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/pbs-guppy_alignerCRE_qscore_81Q-50Q.sh
```

## STRique analysis

```
#### passaggio 50Q-80Q
echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_81Q-50Q_ratio1-100_150_600bp_qscore10.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_81Q-50Q_ratio1-100_150_600bp_qscore10.err -v sam="/lustre/home/enza/cattaneo/data/AC_2020_NANOPORE_SPIKE_IN/81Q_50Q_1to100/20201223_1222_MN29119_AEJ713_0cf6731f/alignment/all_fastq.sam",fofn="/lustre/home/enza/cattaneo/data/AC_2020_NANOPORE_SPIKE_IN/81Q_50Q_1to100/20201223_1222_MN29119_AEJ713_0cf6731f/fast5_pass/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/AC2020_Nanopore_PCR6_ha_pcr_flg/HTT_config_AC_PCR6_c15_p52_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.tsv" -N 81Q-50Q.qscore10.count /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/pbs-striqueCount.job
```


Split all_fastq.sam into file with 20k rows (reads)

```
split -l 5000 all_fastq.sam split_fastq_
```

Run STRique with splitted fastq

cat all_fastq.sam | grep -w "SN:T" > header.txt
for n in b c d e f g h i j k  ; do cat header.txt split_fastq_a$n > split_fastq_$n; done
mv split_fastq_aa split_fastq_a
for n in b c d e f g h i j k ; do rm split_fastq_a$n ; done
rm header.txt



for n in 10 ; do for s in a b c d e f g h i j k ; do echo qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/striqueCount_81Q-50Q_ratio1-100.$s.qscore$n.out -e /lustrehome/gianluca/junk/cattaneo/striqueCount_81Q-50Q_ratio1-100.$s.qscore$n.err -v sam="/lustre/home/enza/cattaneo/data/AC_2020_NANOPORE_SPIKE_IN/81Q_50Q_1to100/20201223_1222_MN29119_AEJ713_0cf6731f/alignment/split_fastq_$s",fofn="/lustre/home/enza/cattaneo/data/AC_2020_NANOPORE_SPIKE_IN/81Q_50Q_1to100/20201223_1222_MN29119_AEJ713_0cf6731f/fast5_pass/reads.fofn",config="/lustre/home/enza/cattaneo/config_file/AC2020_Nanopore_PCR6_ha_pcr_flg/HTT_config_AC_PCR6_c15_p52_150_600bp_CAG.tsv",output="/lustrehome/gianluca/strique/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.$s.tsv" -N $s.81Q-50Q.qs$n.count /lustrehome/gianluca/strique/jobs/AC_2020_NANOPORE_SPIKE_IN/pbs-striqueCount.job ; done ; done | less -S



python RepeatHMM/bin/repeatHMM.py FASTQinput --repeatName HTT --GapCorrection 1 --FlankLength 30 --UserDefinedUniqID sca3_pcr25_raw_test --fastq /lustre/home/enza/cattaneo/data/AC_2020_NANOPORE_SPIKE_IN/81Q_50Q_1to100/20201223_1222_MN29119_AEJ713_0cf6731f/fastq_pass/all_pass.fastq --outFolder logfq --Patternfile RepeatHMM/bin/reference_sts/hg38/hg38.predefined.pa --hgfile /lustre/home/enza/hgdp/fasta/GRCh38_full_analysis_set_plus_decoy_hla.fa --hg hg38




###########################################


#### replicate 19CAG-1 NEO
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_19CAG-1.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerNEO_19CAG-1.qscore10.err -N guppyAlignNEO_19CAG-1.qscore10 /lustrehome/gianluca/strique/jobs/20201013/pbs-guppy_alignerNEO_qscore_19CAG-1.sh

#### replicate 19CAG-1 CRE
echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_19CAG-1.qscore10.out -e /lustrehome/gianluca/junk/cattaneo/cpu-guppy_alignerCRE_19CAG-1.qscore10.err -N guppyAlignCRE_19CAG-1.qscore10 /lustrehome/gianluca/strique/jobs/20201013/pbs-guppy_alignerCRE_qscore_19CAG-1.sh
