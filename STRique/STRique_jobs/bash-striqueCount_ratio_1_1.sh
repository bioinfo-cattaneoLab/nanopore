cat /lustre/home/enza/cattaneo/data/erc_pilot_fast5/SAM/PASS_SAM/ratio-1_1/21_109_1_1_20190201_0947_MN29119_FAK49673_a9e8b3a2_fastq_fastq_runid_361d77ef4849a8b084ddc941d7c81aec28e5c109_$1.fastq.sam | /bin/singularity exec -B /lustre/home/enza/ /lustre/home/enza/biocontainers/strique_latest.sif python3 /app/scripts/STRique.py count --t 4 --log_level debug /lustre/home/enza/cattaneo/data/erc_pilot_fast5/109-21CAG-1_1ratio/reads.fofn /lustre/home/enza/cattaneo/config_file/r9_4_450bps.model /lustre/home/enza/cattaneo/config_file/HTT_config_$2.tsv > /lustrehome/gianluca/striqueOutput/ratio1_1_$1_$2.tsv && touch /lustrehome/gianluca/strique_ratio1_1_$1_$2.tsv_ok 
