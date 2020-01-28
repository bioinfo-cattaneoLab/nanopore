# 1 Index fast5 file:

### Indexing is essential right functioning of STRique software, we have a [job](STRique_jobs/condor-striqueIndex.job) for do that.and following we have a command line:
```
condor_submit -name ettore -a "barcode=barcode01" /path/to/my/job
```
# 2 Count repeats:

### 2.1 For counting the repeats is important write a config-file using parameters that you find in yours Sam file. If you have already a SAM-file you can skip the following command line otherwise you have to convert a BAM-file in SAM.

```
condor_submit -name ettore -a "n=1" /path/to/my/job
```

### 2.2 With a SAM file run this command line using this [job]()