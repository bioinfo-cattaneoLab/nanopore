library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/plots/"

c15_p62 = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p52_qscore10.150_600bp_CAG.tsv", header=T, sep= "\t")

c15_p62 = c15_p62 %>% group_by(ID) %>% filter(n()==1)

c15_p62$qscore = "10"
c15_p62$replicate = "1"
c15_p62$experiment = "c15_p62"

c15_p70 = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p70_qscore10.150_600bp_CAG.tsv", header=T, sep= "\t")

c15_p70 = c15_p70 %>% group_by(ID) %>% filter(n()==1)

c15_p70$qscore = "10"
c15_p70$replicate = "1"
c15_p70$experiment = "c15_p70"


final_df = rbind(c15_p62, c15_p70)

names(final_df)[names(final_df)=="ID"] <- "read_id"

final_df %>% filter (count > 0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count, color = experiment)) + geom_density(aes(linetype=experiment)) + ggtitle("All Reads") 

ggsave(paste(PLOT_PATH,"strique_p62-70.png", sep=""))

############# NeoR

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

#### plot only reads that align with neoR

final_dataframe %>% filter (count > 0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count, color = experiment.x)) + geom_density(aes(linetype=experiment.x)) + ggtitle("Reads aligned with NeoR")

ggsave(paste(PLOT_PATH,"strique_p62-70_neo.png", sep=""))
