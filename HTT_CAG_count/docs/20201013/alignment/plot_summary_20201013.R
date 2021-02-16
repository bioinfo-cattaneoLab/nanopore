library(tidyverse)

PLOT_PATH="/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/plots/"

final_df=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/summary/alignment_summary_rep1_qscore-7.txt", header=T,sep='\t')

final_df$qscore = "7"
final_df$replicate = "1"
final_df$experiment = "21Q"

for ( rep in c(2,3)) {

REP=rep
#DATAFRAME = paste("myd_", QSCORE , sep="")

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/summary/alignment_summary_rep", REP ,"_qscore-7.txt", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$qscore = "7"
temp_name$replicate = as.character(rep)
temp_name$experiment = "21Q"

final_df = rbind(final_df, temp_name)

}


for ( qscore in c(10,13)) {

for ( rep in c(1,2,3)) {
QSCORE= qscore
REP=rep

#DATAFRAME = paste("myd_", QSCORE , sep="")

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/summary/alignment_summary_rep", REP ,"_qscore-", QSCORE ,".txt", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$qscore = as.character(qscore)
temp_name$replicate = as.character(rep)
temp_name$experiment = "21Q"

final_df = rbind(final_df, temp_name)

}
}

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=qscore)  ) + geom_density()  +ggtitle('Alignment Coverage for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_coverage_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_insertions, color=qscore)  ) + geom_density()  +ggtitle('Number of insertions for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_num_insertions_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_num_deletions, color=qscore)  ) + geom_density()  +ggtitle('Number of deletions for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_num_deletions_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_identity, color=qscore)  ) + geom_density()  +ggtitle('Alignment_identity for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_identity_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_accuracy, color=qscore)  ) + geom_density()  +ggtitle('Alignment_accuracy for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_accuracy_summary.png", sep=""))

final_df %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_score, color=qscore)  ) + geom_density()  +ggtitle('Alignment_score for each Qscore value')

ggsave(paste(PLOT_PATH,"alignment_score_summary.png", sep=""))
