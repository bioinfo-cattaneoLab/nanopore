library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/"

final_df=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_qscore-10.txt", header=T,sep='\t')

final_df$qscore = "10"
final_df$replicate = "1"
final_df$experiment = "c15_p52"

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment Coverage for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_coverage_summary-p52.png", sep=""))

final_df %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment genome_start for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_start_summary-p52.png", sep=""))

final_df %>% filter(alignment_genome_end!=-1 )  %>% ggplot( aes(alignment_genome_end, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment genome_end for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary-p52.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Number of insertions for each Qscore value') + facet_grid( experiment ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary-p52.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Number of deletions for each Qscore value') + facet_grid( experiment ~., scales="free")

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/"

final_df_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_neo_qscore-10.txt", header=T,sep='\t')

final_df_neo$qscore = "10"
final_df_neo$replicate = "1"
final_df_neo$experiment = "c15_p52-NEO"

final_df_neo = final_df_neo %>% filter(alignment_coverage != "-1")

final_df=merge(final_df_neo,final_df, by = "read_id")

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_coverage.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment Coverage for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_coverage_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_genome_start.y!=-1 )  %>% ggplot( aes(alignment_genome_start.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment genome_start for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_start_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_genome_end.y!=-1 )  %>% ggplot( aes(alignment_genome_end.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment genome_end for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_genome_end_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_num_insertions.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Number of insertions for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_num_deletions.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Number of deletions for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_identity.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment_identity for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_identity_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_accuracy.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment_accuracy for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_accuracy_summary-p52-NEO.png", sep=""))

final_df %>% filter(alignment_coverage.y!=-1 )  %>% ggplot( aes(alignment_score.y, color=qscore.y)  ) + geom_density(aes(linetype = experiment.x))  +ggtitle('Alignment_score for each Qscore value') + facet_grid( experiment.x ~., scales="free")

ggsave(paste(PLOT_PATH,"alignment_score_summary-p52-NEO.png", sep=""))
