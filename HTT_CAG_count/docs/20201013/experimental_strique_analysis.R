library(tidyverse)

df_150_600bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore7.rep1.150_600bp_CAG.tsv",header=T, sep="\t")

df_150_600bp$lengthPS = "150bp"
df_150_600bp$lengthRef_interval = "600bp"
df_150_600bp$QSCORE = '7'
df_150_600bp$replicate = "1"
df_150_600bp$experiment = "21Q"
df_150_600bp = df_150_600bp %>% group_by(ID) %>% filter(n()==1) # voglio eliminare gli ID doppi, rifare usando uniq di bash

for ( rep in c(2,3)) {

REP=rep

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore7.rep", REP ,".150_600bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "600bp"
temp_name$QSCORE = '7'
temp_name$replicate = as.character(rep)
temp_name$experiment = "21Q"
temp_name = temp_name %>% group_by(ID) %>% filter(n()==1)

df_150_600bp = rbind(df_150_600bp, temp_name)

}

for ( qscore in c(10,13)) {

for ( rep in c(1,2,3)) {
QSCORE= qscore
REP=rep

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore", QSCORE ,".rep", REP ,".150_600bp_CAG.tsv" , sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "600bp"
temp_name$QSCORE = as.character(qscore)
temp_name$replicate = as.character(rep)
temp_name$experiment = "21Q"
temp_name = temp_name %>% group_by(ID) %>% filter(n()==1)

df_150_600bp = rbind(df_150_600bp, temp_name)

}
}

final_df = df_150_600bp

reads_usedBy_STRique=read.table("~/projects/cattaneo/docs/20201013/reads_usedBy_STRique.tsv", header=T, sep="\t")

final_df = merge(final_df, reads_usedBy_STRique, by=c("QSCORE", "replicate") )

#Change levels order for QSCORE column
final_df$QSCORE = factor(final_df$QSCORE, levels = c(7, 10, 13))

########### JITTER

#final_df %>% filter(count > 0 ,score_prefix > 5, score_suffix >5 ) %>% ggplot(aes(replicate, count, fill=QSCORE)) + geom_jitter()

final_df %>% filter(count > 0 ,score_prefix > 5, score_suffix >5 ) %>% ggplot(aes(replicate, count)) + geom_jitter(aes(alpha=0.01,color=QSCORE)) + ylim(0,200)

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/replicate_21Q_scorePS-5_ylim200.png")

# final_df %>% filter(count > 0 ,score_prefix > 6, score_suffix >6 ) %>% ggplot(aes(replicate, count, fill=QSCORE)) + geom_jitter()
#
# final_df %>% filter(count > 0 ,score_prefix > 6, score_suffix >6 ) %>% ggplot(aes(replicate, count, fill=QSCORE)) + geom_jitter() + ylim(0,200)
#
# ########### BOXPLOT
# final_df %>% filter(count > 0 ,score_prefix > 6, score_suffix >6 ) %>% ggplot(aes(replicate, count, fill=QSCORE)) + geom_boxplot() + ylim(0,200)


########### write table for counting line
# PS6=final_df %>% filter(count > 0 ,score_prefix > 6, score_suffix >6 )
# PS5=final_df %>% filter(count > 0 ,score_prefix > 5, score_suffix >5 )
# write.table(PS6, "provaPS6.tsv", quote=F, row.names=F)
# write.table(PS5, "provaPS5.tsv", quote=F, row.names=F)

########### in bash :
# row for each replicate
# gianluca@MBP:~/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data|⇒  cat provaPS5.tsv| grep -w "3" |wc -l
#   128812
# gianluca@MBP:~/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data|⇒  cat provaPS5.tsv| grep -w "2" |wc -l
#    78486
# gianluca@MBP:~/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data|⇒  cat provaPS5.tsv| grep -w "1" |wc -l
#    60885
