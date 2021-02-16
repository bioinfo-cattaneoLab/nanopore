## Methylation state on nanopore Reads

### Install requirements

####Install medaka with CONDA
```
conda create -n medaka -c conda-forge -c bioconda medaka
conda activate medaka
```
####Install Fast5mod with SINGULARITY
```
singularity pull docker://nanozoo/fast5mod:1.0.0--7f4cc92
```
