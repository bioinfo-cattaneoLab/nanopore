# 1 Index fast5 file:

### Indexing is essential right functioning of STRique software [job](STRique_jobs/condor-striqueIndex.job). Command line:

```
condor_submit -name ettore -a "folder=109-21CAG-1_1ratio" /path/to/my/job
```

# 2 Count repeats:

### 2.1 For counting the repeats is important write a config-file using parameters that you find in yours Sam file. If you have already a SAM-file jump to 2.2 and skip the following command line otherwise you have to convert a BAM-file in SAM with this [job](STRique_jobs/condor-bam2sam.job).

```
condor_submit -name ettore -a "n=1" /path/to/my/job
```

### 2.2  Following command-line is used for count repeats using a specific config-file [job](STRique_jobs/condor-striqueCount.job)

```
condor_submit -name ettore -a "n=1" -a "config=150-0-p_CAG" /path/to/my/job
```

