




### Prima di fare il basecalling bisogna separare i fast5 da multi a singoli

https://github.com/nanoporetech/ont_fast5_api

```
multi_to_single_fast5 -i ~/testing/scrappy/data/fast5/109-21CAG-1_1ratio/ -s /lustrehome/gianluca/testing/scrappy/data/single_fast5
```
### basecalling , fa fast5 a bam/sam/fastq , installato la versione python SCRAPPY 
 
https://github.com/nanoporetech/scrappie

```
scrappy /lustrehome/gianluca/testing/scrappy/data/single_fast5/0/346921ca-82a2-470c-bbf2-90b4bd358aa6.fast5 rgrgr_r94 > ~/testing/scrappy/346921ca-82a2-470c-bbf2-90b4bd358aa6.fa
```

### read-to-read overlap finding , installato su conda (py38)

https://github.com/lh3/minimap2

### assembly , installed by conda 

https://github.com/marbl/canu

### BWA-MEM , minimap2


### nanopolish
