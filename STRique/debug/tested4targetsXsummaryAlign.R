library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/20200813/alignment/plots/"

reads_strique_htt = read.table("~/projects/cattaneo/strique_log/good_reads.txt" , header=F , sep="\t")

summ_qscore7= read.table("~/projects/cattaneo/docs/20200813/alignment/summary/alignment_summary_qscore-7.txt", header=T, sep="\t")


#change name of id_no_htt
colnames(reads_strique_htt)[colnames(reads_strique_htt) == "V1"] <- "read_id"

reads_strique_htt$Use="Used_by_strique"

merged_df=merge(summ_qscore7, reads_strique_htt, by = "read_id", all.x = T)

merged_df %>% distinct() %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=Use)  ) + geom_density()  +ggtitle('Alignment Coverage Qscore 7 ')

ggsave(paste(PLOT_PATH,"alignment_coverage_summary_goodVSbad.png", sep=""))

merged_df %>% distinct() %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=Use)  ) + geom_density()  +ggtitle('Alignment number of insertions Qscore 7 ')

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary_goodVSbad.png", sep=""))

merged_df %>% distinct() %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=Use)  ) + geom_density()  +ggtitle('Alignment number of deletions Qscore 7 ')

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary_goodVSbad.png", sep=""))
