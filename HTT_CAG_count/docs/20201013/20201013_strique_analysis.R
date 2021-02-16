library(tidyverse)

df_150_600bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore7.rep1.150_600bp_CAG.tsv",header=T, sep="\t")

df_150_600bp$lengthPS = "150bp"
df_150_600bp$lengthRef_interval = "600bp"
df_150_600bp$QSCORE = 7
df_150_600bp$replicate = "1"
df_150_600bp$experiment = "21Q"

for ( rep in c(2,3)) {

REP=rep

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore7.rep", REP ,".150_600bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "600bp"
temp_name$QSCORE = 7
temp_name$replicate = as.character(rep)
temp_name$experiment = "21Q"

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

df_150_600bp = rbind(df_150_600bp, temp_name)

}
}

final_df = df_150_600bp

reads_usedBy_STRique=read.table("~/projects/cattaneo/docs/20201013/reads_usedBy_STRique.tsv", header=T, sep="\t")

final_df = merge(final_df, reads_usedBy_STRique, by=c("QSCORE", "replicate") )

#Change levels order for QSCORE column
final_df$QSCORE = factor(final_df$QSCORE, levels = c(7, 10, 13))

#Calculate Mode

#Create the function.
getmode <- function(v) {
   uniqv <- unique(v)
   uniqv[which.max(tabulate(match(v, uniqv)))]
}

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>%  group_by(replicate, QSCORE, lengthPS, lengthRef_interval, reads_used) %>% summarize(mean=mean(count), median=median(count), mode=getmode(count), sd=sd(count)) %>% write.table("~/projects/cattaneo/docs/20201013/statistics_fromDiff_replicates.tsv", quote=F, row.names=F, sep="\t")



#CAG count Distribution

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(replicate),linetype = QSCORE)) + xlim ( 35, 6000 ) + ggtitle( "CAG count with different Qscore, 150bp Prefix/Suffix length" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/longCAG.png")

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(replicate),linetype = QSCORE)) + xlim ( 1000, 2500) + ggtitle( "CAG count with different Qscore, 150bp Prefix/Suffix length" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/preciselongCAG.png")

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = replicate)) + xlim ( 0, 150) + ggtitle( "CAG count with different Qscore, 150bp Prefix/Suffix length" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/expectedCAG.png")

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = replicate)) + ggtitle( "CAG count with different Qscore, 150bp Prefix/Suffix length" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/allReadsCAG.png")

final_df %>% filter(count > 0 & score_prefix > 6 & score_suffix > 6 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(replicate),linetype = QSCORE)) + xlim ( 35, 150) + ggtitle( "CAG count with different Qscore, 150bp Prefix/Suffix length" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/afterExpectedCAG.png")

#### reads used by strique

myd=read.table("~/projects/cattaneo/docs/20201013/reads_usedBy_STRique.tsv", header=T, sep="\t")

ggplot(final_df, aes(as.factor(replicate), percent_usedBy_STRique)) + geom_point(aes(color=as.factor(QSCORE))) + ylab("Percentage") + xlab("Replicate Name") + scale_color_discrete(name = "Qscore")  + ggtitle( "Percent of reads used by STRique" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/percenteReads_usedBy_STRique.png", height= 15 , width=10, units="cm")

ggplot(final_df, aes(as.factor(replicate), reads_used)) + geom_point(aes(color=as.factor(QSCORE))) + ylab("Number of Reads") + xlab("Replicate Name") + scale_color_discrete(name = "Qscore")  + ggtitle( "Number of reads used by STRique" )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/plots/numberReads_usedBy_STRique.png", height= 15 , width=10, units="cm")

#Mean of CAG count for lengthRef_interval

final_df %>% filter (count > 0 & score_prefix > 6 & score_suffix > 6) %>% group_by(replicate, QSCORE, lengthPS, lengthRef_interval, reads_used) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( replicate , mean )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = reads_used)) + ggtitle( "Mean of CAG count \n for lengthRef_interval (count >0)" )

ggsave("~/projects/cattaneo/docs/20201013/plots/meanCAG_4_replicate.png", height= 15 , width=10, units="cm")

#Median of CAG count for lengthRef_interval

final_df %>% filter (count > 0 & score_prefix > 6 & score_suffix > 6) %>% group_by(replicate, QSCORE, lengthPS, lengthRef_interval, reads_used) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( replicate , median )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = reads_used)) + ggtitle( "Median of CAG count \n for lengthRef_interval (count >0)" )

ggsave("~/projects/cattaneo/docs/20201013/plots/medianCAG_4_replicate.png", height= 15 , width=10, units="cm")

#Mode of CAG count

final_df %>% filter (count > 0 & score_prefix > 6 & score_suffix > 6) %>%  group_by(replicate, QSCORE, lengthPS, lengthRef_interval, reads_used) %>% summarize(mean=mean(count), median=median(count), sd=sd(count), mode=getmode(count)) %>% ggplot( aes( replicate , mode )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = reads_used)) + ggtitle("Mode of CAG count \n for lengthRef_interval (count >0)")

ggsave("~/projects/cattaneo/docs/20201013/plots/modeCAG_4_replicate.png", height= 15 , width=10, units="cm")
