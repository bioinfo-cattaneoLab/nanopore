library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/"

final_df=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_qscore-7.txt", header=T,sep='\t')

final_df$qscore = "7"
final_df$replicate = "1"
final_df$experiment = "c15_p52"

for ( qscore in c(10,13)) {

for ( rep in c(1)) {
QSCORE= qscore
REP=rep

#DATAFRAME = paste("myd_", QSCORE , sep="")

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_qscore-", QSCORE ,".txt", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$qscore = as.character(qscore)
temp_name$replicate = as.character(rep)
temp_name$experiment = "c15_p52"

final_df = rbind(final_df, temp_name)

}
}

final_df$qscore = factor(final_df$qscore, levels = c(7, 10, 13))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment Coverage for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_coverage_summary.png", sep=""))

final_df %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment genome_start for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_start_summary.png", sep=""))

final_df %>% filter(alignment_genome_end!=-1 )  %>% ggplot( aes(alignment_genome_end, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment genome_end for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Number of insertions for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Number of deletions for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_identity, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment_identity for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_identity_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_accuracy, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment_accuracy for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_accuracy_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_score, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment_score for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_score_summary.png", sep=""))
