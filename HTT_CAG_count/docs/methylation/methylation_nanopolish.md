# Methylation detection (5mCpG) using Nanopore Reads

## Load Anaconda3

```
source ~/.bashrc
```

have to make uniq file with all FASTQ reads

## Nanopolish

### Index Fastq with Fast5
```
/lustrehome/gianluca/src/nanopolish/./nanopolish index -d /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/fast5_pass/ /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.fastq.gz

qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/nanopolish_index.out -e /lustrehome/gianluca/junk/cattaneo/nanopolish_index.err -N nanopolish_index /lustrehome/gianluca/jobs/methylation/pbs-nanopolish_index.sh
```

### Alignment using Minimap2 using reference Whole-genome
```
minimap2 -a -x map-ont /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.fastq.gz | samtools sort -T tmp -o /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.sorted.bam
samtools index /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.sorted.bam

qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/meth_align.out -e /lustrehome/gianluca/junk/cattaneo/meth_align.err -N meth_align /lustrehome/gianluca/jobs/methylation/pbs-alignment.sh
```

### Call-Methylation
```
/lustrehome/gianluca/src/nanopolish/.nanopolish call-methylation -t 8 -r /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.fastq.gz -b /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/fastq_runid_c73b51fe18f5f448b7c2076746916e1aa497722d_0_0.sorted.bam -g /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -w "chr12:7,789,402-7,799,146" > /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/methylation_calls.tsv

for c in $(seq 1 22) ; do echo qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/meth_call.$c.out -e /lustrehome/gianluca/junk/cattaneo/meth_call.$c.err -v c="$c" -N meth_call.$c /lustrehome/gianluca/jobs/methylation/pbs-nanopolish_methCall.sh ; done

for c in X Y ; do qsub -q testqueue -l nodes=1:ppn=10 -o /lustrehome/gianluca/junk/cattaneo/meth_call.$c.out -e /lustrehome/gianluca/junk/cattaneo/meth_call.$c.err -v c="$c" -N meth_call.$c /lustrehome/gianluca/jobs/methylation/pbs-nanopolish_methCall.sh ; done

```

### Calculate Methylation Frequency
```
python3 /lustrehome/gianluca/src/nanopolish/scripts/calculate_methylation_frequency.py /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/methylation_calls.tsv > /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/20201027_1147_MN29119_AEG933_b0c009ef/methylation/methylation_frequency.tsv
```

### Gene name, gene position from specific nanopolish analysis 
```
POU5F1	chr6:31,164,337-31,170,682	NC_000006.12:31,163,702-31,171,317
NANOG	chr12:7,789,402-7,799,146	NC_000012.12:7,788,427-7,800,121
SOX2	chr3:181,711,925-181,714,436	NC_000013.11:112,066,693-112,072,162
PAX6	chr11:31,789,026-31,817,961	NC_000011.10:31,786,132-31,820,855
EED	chr11:86,244,753-86,285,420	NC_000011.10:86,240,686-86,289,487
EZH2	chr7:148,807,374-148,884,344	NC_000007.14:148,799,677-148,892,041
SUZ12	chr17:31,937,007-32,001,040	NC_000017.11:31,930,604-32,007,443
WT1	chr11:32,387,775-32,435,539	NC_000011.10:32,382,998-32,440,316
CCDN1	chr11:69,641,156-69,654,474	NC_000011.10:69,639,824-69,655,806
RXRG	chr1:165,400,922-165,445,126	NC_000001.11:165,396,501-165,449,547
KDM6A_UTX	chrX:44,873,182-45,112,779	NC_000023.11:44,849,222-45,136,739
KDM6B_JMJD3	chr17:7,834,210-7,854,796	NC_000017.11:7,832,151-7,856,855
DNMT3A	chr2:25,227,874-25,342,590	NC_000002.12:25,216,402-25,354,062
DNMT3B	chr20:32,762,385-32,809,356	NC_000020.11:32,757,688-32,814,053
DNMT1	chr19:10,133,346-10,194,953	NC_000019.10:10,127,185-10,201,114
```

Use Nanopolish for obtain only specific methylation pattern from a specific gene position :
```
cat /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/gene_position.bed | cut -f1,2 | while IFS="$(printf '\t')" read -r f1 f2; do /lustrehome/gianluca/src/nanopolish/./nanopolish call-methylation -t 10 -r /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/whole-genome.fastq.gz -b /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/whole-genome.sorted.bam -g /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -w "$f2" > /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_calls.$f1.tsv ; done

cat /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/gene_position.bed | cut -f1 | while IFS="$(printf '\t')" read -r f1 ; do /src/anaconda3/bin/python3 /lustrehome/gianluca/src/nanopolish/scripts/calculate_methylation_frequency.py /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_calls.$f1.tsv > /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_frequency.$f1.tsv ; done
```
### install pycoMeth (downstream analysis)

```
conda install -c aleg -c plotly pycometh
```
importante e' il file .BED che viene caricato in IGV
```
cat /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/gene_position.bed | cut -f1 | while IFS="$(printf '\t')" read -r f1 ; do pycoMeth CpG_Aggregate -i /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_calls.$f1.tsv -f /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -b /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/CpG_Aggregate_$f1.bed -t /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/CpG_Aggregate_$f1.tsv -d 2 -s Sample1 --progress ; done
```
<!-- pycoMeth Interval_Aggregate -i /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/CpG_Aggregate_NANOG.tsv -f /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -b /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/Interval_Aggregate_NANOG.bed -t /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/Interval_Aggregate_NANOG.tsv --interval_size 500 --min_cpg_per_interval 5 -s NANOG --progress

pycoMeth Comp_Report -i /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/Interval_Aggregate_NANOG.tsv -g /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/NANOG.gff3 -f /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -o /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/NANOG.html --pvalue_threshold 0.05 --verbose -->


first bgzip and tabix -S1 -s1 -b2 -e3 of methylation_frequency.NANOG.tsv
```
cat /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/gene_position.bed | cut -f1,2 | while IFS="$(printf '\t')" read -r f1 f2 ; do methplotlib -m /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_frequency.$f1.tsv -n $f1 -w $f2 -o /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_browser_$f1.html -q /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/qc_report_methylation_browser_$f1.html ; done
```

<!-- methplotlib -m /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_frequency.NANOG.tsv -n NANOG -w chr12:7,789,402-7,799,146 -o /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/methylation_browser_NANOG.html -q /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation/qc_report_methylation_browser_NANOG.html --simplify   -->


### Megalodon

install
```
src/anaconda3/bin/pip install megalodon
```

Download more accurate modified base model for guppy from Rerio repository
```
git clone https://github.com/nanoporetech/rerio
rerio/./download_model.py
```

```
megalodon /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/fast5_pass/ --guppy-params -d /lustrehome/gianluca/src/rerio/basecall_models/ --guppy-config res_dna_r941_min_modbases_5mC_CpG_v001.cfg --outputs /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/methylation_megalodon/basecalls /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/mappings /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/mod_mappings /lustre/home/enza/cattaneo/data/methylation/methylation-RUES-2/20CAG-cl30/20201111_1149_MN29119_FAO37652_e8e9cd05/mods --reference /lustre/home/enza/cattaneo/data/Methylation-RUES2-FLG/RUES2-20CAG/reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna --mod-motif m CG 0 --devices 0 1 --processes 40

qsub -q testqueue -l nodes=1:ppn=40 -o /lustrehome/gianluca/junk/cattaneo/megalodon_meth.out -e /lustrehome/gianluca/junk/cattaneo/megalodon_meth.err -N megalodon_meth /lustrehome/gianluca/jobs/methylation/pbs-megalodon.sh
```
