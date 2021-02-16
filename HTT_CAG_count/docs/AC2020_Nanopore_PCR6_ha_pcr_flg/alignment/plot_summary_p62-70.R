library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/"

c15_p62=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_qscore-10.txt", header=T,sep='\t')

c15_p62$qscore = "10"
c15_p62$replicate = "1"
c15_p62$experiment = "c15_p62"

c15_p70=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_p70_qscore-10.txt", header=T,sep='\t')

c15_p70$qscore = "10"
c15_p70$replicate = "1"
c15_p70$experiment = "c15_p70"

final_df = rbind(c15_p62, c15_p70)

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=experiment)  ) + geom_density()  +ggtitle('Alignment Coverage ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_coverage_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start, color=experiment)  ) + geom_density()  +ggtitle('Alignment genome_start ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_start_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_genome_end!=-1 )  %>% ggplot( aes(alignment_genome_end, color=experiment)  ) + geom_density()  +ggtitle('Alignment genome_end ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=experiment)  ) + geom_density()  +ggtitle('Number of insertions ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=experiment)  ) + geom_density()  +ggtitle('Number of deletions ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_identity, color=experiment)  ) + geom_density()  +ggtitle('Alignment_identity ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_identity_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_accuracy, color=experiment)  ) + geom_density()  +ggtitle('Alignment_accuracy ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_accuracy_summary_p62-70.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_score, color=experiment)  ) + geom_density()  +ggtitle('Alignment_score ') #+ facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_score_summary_p62-70.png", sep=""))

######################### alignment with NeoR

c15_p70_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_p70-NEO_qscore-10.txt", header=T,sep='\t')

c15_p70_neo$qscore = "10"
c15_p70_neo$replicate = "1"
c15_p70_neo$experiment = "c15_p70"


c15_p70_neo = c15_p70_neo %>% filter(alignment_coverage != "-1")

c15_p62_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_neo_qscore-10.txt", header=T,sep='\t')

c15_p62_neo$qscore = "10"
c15_p62_neo$replicate = "1"
c15_p62_neo$experiment = "c15_p62"

c15_p62_neo = c15_p62_neo %>% filter(alignment_coverage != "-1")

final_df_neo = rbind(c15_p70_neo, c15_p62_neo)

final_dataframe = merge(final_df_neo , final_df, by=c("read_id"))

## select only id's with neoR

id_neo_df = final_dataframe %>% select(read_id, alignment_genome.y, alignment_direction.y,alignment_genome_start.y,alignment_genome_end.y,alignment_strand_start.y,alignment_strand_end.y,alignment_num_insertions.y,alignment_num_deletions.y,alignment_num_aligned.y,alignment_num_correct.y,alignment_identity.y,alignment_accuracy.y,alignment_score.y,alignment_coverage.y,qscore.y,replicate.y,experiment.y)

names(id_neo_df)[names(id_neo_df)=="alignment_genome.y"] <- "alignment_genome"
names(id_neo_df)[names(id_neo_df)=="alignment_direction.y"] <- "alignment_direction"
names(id_neo_df)[names(id_neo_df)=="alignment_genome_start.y"] <- "alignment_genome_start"
names(id_neo_df)[names(id_neo_df)=="alignment_genome_end.y"] <- "alignment_genome_end"
names(id_neo_df)[names(id_neo_df)=="alignment_strand_start.y"] <- "alignment_strand_start"
names(id_neo_df)[names(id_neo_df)=="alignment_strand_end.y"] <- "alignment_strand_end"
names(id_neo_df)[names(id_neo_df)=="alignment_num_insertions.y"] <- "alignment_num_insertions"
names(id_neo_df)[names(id_neo_df)=="alignment_num_deletions.y"] <- "alignment_num_deletions"
names(id_neo_df)[names(id_neo_df)=="alignment_num_aligned.y"] <- "alignment_num_aligned"
names(id_neo_df)[names(id_neo_df)=="alignment_num_correct.y"] <- "alignment_num_correct"
names(id_neo_df)[names(id_neo_df)=="alignment_identity.y"] <- "alignment_identity"
names(id_neo_df)[names(id_neo_df)=="alignment_accuracy.y"] <- "alignment_accuracy"
names(id_neo_df)[names(id_neo_df)=="alignment_score.y"] <- "alignment_score"
names(id_neo_df)[names(id_neo_df)=="alignment_coverage.y"] <- "alignment_coverage"
names(id_neo_df)[names(id_neo_df)=="qscore.y"] <- "qscore"
names(id_neo_df)[names(id_neo_df)=="replicate.y"] <- "replicate"
names(id_neo_df)[names(id_neo_df)=="experiment.y"] <- "experiment"

final_df$align_neo = "no"
id_neo_df$align_neo = "yes"

df_plot = rbind(final_df, id_neo_df)

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment Coverage ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_coverage_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment genome_start ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_start_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_genome_end!=-1 )  %>% ggplot( aes(alignment_genome_end, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment genome_end ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Number of insertions ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Number of deletions ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_identity, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment_identity ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_identity_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_accuracy, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment_accuracy ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_accuracy_summary_p62-70_NEO.png", sep=""))

df_plot %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_score, color=experiment)  ) + geom_density(aes(linetype = align_neo))  +ggtitle('Alignment_score ') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_score_summary_p62-70_NEO.png", sep=""))


#####################################  strique #########################################################

# PLOT_PATH_strique="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/plots/"

c15_p62_strique = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p52_qscore10.150_600bp_CAG.tsv", header=T, sep= "\t")

c15_p62_strique = c15_p62_strique %>% group_by(ID) %>% filter(n()==1)

c15_p62_strique$qscore = "10"
c15_p62_strique$replicate = "1"
c15_p62_strique$experiment = "c15_p62"

c15_p70_strique = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p70_qscore10.150_600bp_CAG.tsv", header=T, sep= "\t")

c15_p70_strique = c15_p70_strique %>% group_by(ID) %>% filter(n()==1)

c15_p70_strique$qscore = "10"
c15_p70_strique$replicate = "1"
c15_p70_strique$experiment = "c15_p70"


final_df_strique = rbind(c15_p62_strique, c15_p70_strique)

names(final_df_strique)[names(final_df_strique)=="ID"] <- "read_id"


##################################### Genome End for reads with 0 < count < 37.5 ##########################################################

test = merge(df_plot , final_df_strique, by=c("read_id"))

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5) %>% ggplot( aes(alignment_genome_end,color=experiment.x)  ) + geom_density()  +ggtitle('Genome End for reads with count > 0 & count < 37.5') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary_STRIQUE-25Qcount_p62-70.png", sep=""))

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5) %>% ggplot( aes(alignment_genome_end,fill=experiment.x)  ) + geom_histogram()  +ggtitle('Genome End for reads with count > 0 & count < 37.5') + facet_grid( align_neo ~., scales="free")
##################################### Genome End for reads with count > 37.5 ##########################################################

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5) %>% ggplot( aes(alignment_genome_end,color=experiment.x)  ) + geom_density()  +ggtitle('Genome End for reads with count > 37.5') + facet_grid( align_neo ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary_STRIQUE-50Qcount_p62-70.png", sep=""))

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5) %>% ggplot( aes(alignment_genome_end,fill=experiment.x)  ) + geom_histogram()  +ggtitle('Genome End for reads with count > 37.5') + facet_grid( align_neo ~., scales="free")
################################## ratio for reads with count < 37.5

########## p62
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p62", alignment_genome_end < 2000) %>% nrow()
# [1] 9734
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p62", alignment_genome_end > 2000) %>% nrow()
# [1] 5316
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p62") %>% nrow()
# [1] 15050

5316/15050
# [1] 0.3532226
9734/15050
# [1] 0.6467774

############# p70
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p70", alignment_genome_end > 2000) %>% nrow()
# [1] 3037
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p70", alignment_genome_end < 2000) %>% nrow()
# [1] 8641
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p70") %>% nrow()
# [1] 11678

3037/11678
# [1] 0.2600617
8641/11678
# [1] 0.7399383

################################## ratio for reads with count > 37.5

############ p62
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p62", alignment_genome_end < 2000) %>% nrow()
# [1] 4103
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p62", alignment_genome_end > 2000) %>% nrow()
# [1] 39906
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p62") %>% nrow()
# [1] 44009
4103/44009
# [1] 0.09323093
39906/44009
# [1] 0.9067691

############ p70
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p70", alignment_genome_end < 2000) %>% nrow()
# [1] 8616
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p70", alignment_genome_end > 2000) %>% nrow()
# [1] 61842
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p70") %>% nrow()
# [1] 70458

8616/70458
# [1] 0.1222856
61842/70458
# [1] 0.8777144

########################################## Mean, Median, Mode, and sd from count value ####################################
# Calculate Mode

# Create the function.
getmode <- function(v) {
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
}
############ p62
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p62") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p62") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))

############ p70
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p70") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p70") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))

#################### aligned with NeoR

############ p62
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="yes", experiment.x == "c15_p62") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="yes", experiment.x == "c15_p62") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))

############ p70
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="yes", experiment.x == "c15_p70") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="yes", experiment.x == "c15_p70") %>% summarise(mean=mean(count),median=median(count),mode=getmode(count),sd=sd(count))

####################################   Number of reads used for STRique plots   ##################################################

################### count > 37.5
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p62") %>% nrow()
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="no", experiment.x == "c15_p70") %>% nrow()

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="yes", experiment.x == "c15_p62") %>% nrow()
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count > 37.5, align_neo=="yes", experiment.x == "c15_p70") %>% nrow()

################### count < 37.5
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p62") %>% nrow()
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="no", experiment.x == "c15_p70") %>% nrow()

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="yes", experiment.x == "c15_p62") %>% nrow()
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , count < 37.5, align_neo=="yes", experiment.x == "c15_p70") %>% nrow()

test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , align_neo=="no", experiment.x == "c15_p70") %>% nrow()
test %>% filter ( count > 0 , score_prefix >4 , score_suffix > 4 , align_neo=="no", experiment.x == "c15_p62") %>% nrow()
