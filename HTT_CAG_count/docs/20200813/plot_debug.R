library(tidyverse)

df_150=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.150_CAG.tsv",header=T, sep="\t")

df_150$lengthPS = "150bp"
df_150$lengthRef_interval = "full"
df_150$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".150_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "full"

df_150 = rbind(df_150, temp_name)

}

df_150_1000bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.150_1000bp_CAG.tsv",header=T, sep="\t")

df_150_1000bp$lengthPS = "150bp"
df_150_1000bp$lengthRef_interval = "1000bp"
df_150_1000bp$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".150_1000bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "1000bp"

df_150_1000bp = rbind(df_150_1000bp, temp_name)

}

df_150_600bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.150_600bp_CAG.tsv",header=T, sep="\t")

df_150_600bp$lengthPS = "150bp"
df_150_600bp$lengthRef_interval = "600bp"
df_150_600bp$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".150_600bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "150bp"
temp_name$lengthRef_interval = "600bp"

df_150_600bp = rbind(df_150_600bp, temp_name)

}

df_200=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.200_CAG.tsv",header=T, sep="\t")

df_200$lengthPS = "200bp"
df_200$lengthRef_interval = "full"
df_200$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".200_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "200bp"
temp_name$lengthRef_interval = "full"

df_200 = rbind(df_200, temp_name)

}

df_200_1000bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.200_1000bp_CAG.tsv",header=T, sep="\t")

df_200_1000bp$lengthPS = "200bp"
df_200_1000bp$lengthRef_interval = "1000bp"
df_200_1000bp$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".200_1000bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "200bp"
temp_name$lengthRef_interval = "1000bp"

df_200_1000bp = rbind(df_200_1000bp, temp_name)

}

df_200_600bp=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore7.200_600bp_CAG.tsv",header=T, sep="\t")

df_200_600bp$lengthPS = "200bp"
df_200_600bp$lengthRef_interval = "600bp"
df_200_600bp$QSCORE = 7

for ( qscore in c(10, 13)) {

QSCORE = qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore", QSCORE ,".200_600bp_CAG.tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$QSCORE = qscore
temp_name$lengthPS = "200bp"
temp_name$lengthRef_interval = "600bp"

df_200_600bp = rbind(df_200_600bp, temp_name)

}

temp_final_df = rbind(df_150, df_150_1000bp, df_150_600bp, df_200, df_200_1000bp, df_200_600bp)

#write.table(temp_final_df, "HTT_final_df.tsv" , row.names=F , sep="\t", quote=F)

#Load DataFrame

temp_debugLog=read.table("~/projects/cattaneo/debug/info_debugLog_STRque.tsv", header=T , sep="\t")

#temp_final_df=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/HTT_final_df.tsv",header=T, sep="\t")

temp_basecalling = read.table("~/projects/cattaneo/debug/info_basecalling.txt" , header=T , sep = "\t")

#Merge info from STRique's output, STRique's Debug_log and basecalling Info

final_df = merge(temp_final_df, temp_debugLog, by =c("QSCORE","lengthPS","lengthRef_interval"))

final_df = merge(final_df, temp_basecalling, by = "QSCORE")

final_df %>% group_by(QSCORE, lengthPS, lengthRef_interval) %>% summarize(mean=mean(count), median=median(count), sd=sd(count))

#Number of Fail reads after basecalling with specific QSCORE

final_df %>% group_by(QSCORE) %>% summarize(fail_reads=(fast5_reads - basecall_pass_reads)) %>% ggplot( aes(as.factor(QSCORE), fail_reads)) + geom_point () + ggtitle("Fail reads from Basecalling for a specific Qscore")

ggsave("~/projects/cattaneo/debug/plots/fail_reads_basecalling.png")

#CAG count Distribution

final_df %>% filter(count > 0 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = lengthRef_interval)) + ggtitle( "CAG count with different Qscore, Prefix/Suffix length" )

ggsave("~/projects/cattaneo/debug/plots/cag_count_notLim.png")

final_df %>% filter(count > 0 ) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = lengthRef_interval)) + ggtitle( "CAG count" ) + xlim ( 0, 150) + facet_grid( .~ lengthPS)

ggsave("~/projects/cattaneo/debug/plots/cag_count_x150Lim.png")

#Median of CAG count for lengthRef_interval

final_df %>% filter (count > 0) %>% group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( lengthRef_interval , median )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle( "Median of CAG count for lengthRef_interval" )

ggsave("~/projects/cattaneo/debug/plots/medianCAG_4_lengthRef_interval.png")

final_df %>% group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( lengthRef_interval , median )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle( "Median of CAG count for lengthRef_interval" )

ggsave("~/projects/cattaneo/debug/plots/medianCAG_4_lengthRef_interval_noFilterCount.png")

#final_df %>% filter (count > 0) %>% group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( lengthRef_interval , median )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + geom_errorbar( aes(x=lengthRef_interval, ymin=median-sd, ymax=median+sd))

#Mean of CAG count for lengthRef_interval

final_df %>% filter (count > 0) %>% group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( lengthRef_interval , mean )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle( "Mean of CAG count for lengthRef_interval" )

ggsave("~/projects/cattaneo/debug/plots/meanCAG_4_lengthRef_interval.png")

final_df %>% group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count)) %>% ggplot( aes( lengthRef_interval , mean )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle( "Mean of CAG count for lengthRef_interval" )

ggsave("~/projects/cattaneo/debug/plots/meanCAG_4_lengthRef_interval_noFilterCount.png")

#Calculate Mode

#Create the function.
getmode <- function(v) {
   uniqv <- unique(v)
   uniqv[which.max(tabulate(match(v, uniqv)))]
}

final_df %>% filter (count > 0) %>%  group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count), mode=getmode(count)) %>% ggplot( aes( lengthRef_interval , mode )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle("Mode of CAG count for lengthRef_interval")

ggsave("~/projects/cattaneo/debug/plots/modeCAG_4_lengthRef_interval.png")

final_df %>%  group_by(QSCORE, lengthPS, lengthRef_interval, tested_reads) %>% summarize(mean=mean(count), median=median(count), sd=sd(count), mode=getmode(count)) %>% ggplot( aes( lengthRef_interval , mode )) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE), size = tested_reads)) + ggtitle("Mode of CAG count for lengthRef_interval")

ggsave("~/projects/cattaneo/debug/plots/modeCAG_4_lengthRef_interval_noFilterCount.png")

#Number of tested_reads for different lengthRef_interval

final_df %>% ggplot(aes(lengthRef_interval,tested_reads)) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE))) + ggtitle( "Number of tested_reads for different lengthRef_interval" )

ggsave("~/projects/cattaneo/debug/plots/tested_reads_4_lengthRef_interval.png")

#Freq unused reads

final_df %>% group_by(QSCORE, lengthPS, lengthRef_interval) %>% summarize(freq_readsNotUsed=(no_target_reads/SAM_reads)) %>% ggplot(aes(lengthRef_interval,freq_readsNotUsed)) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE))) + ggtitle("Frequency of unused reads")

ggsave("~/projects/cattaneo/debug/plots/freq_unusedReads.png")

#Freq errorAlign_reads

final_df %>% group_by(QSCORE, lengthPS, lengthRef_interval) %>% summarize(freq_errorAlignReads=(errorAlign_reads/SAM_reads)) %>% ggplot(aes(lengthRef_interval, freq_errorAlignReads)) + geom_point(aes(shape=lengthPS, color=as.factor(QSCORE))) + ggtitle("Frequency of errorAlign_reads")

ggsave("~/projects/cattaneo/debug/plots/freq_errorAlignReads.png")


#TO DEVELOP

#final_df %>% filter(count > 0 , score_prefix > 6.7, score_suffix > 6.7, QSCORE == 7 , lengthRef_interval == "600bp") %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = lengthRef_interval)) + ggtitle( "CAG count with different Qscore, Prefix/Suffix length" )

#final_df %>% filter(count > 0 , QSCORE != 13 , lengthRef_interval == "600bp" , lengthPS == "200bp", score_prefix > 7, score_suffix > 7) %>% ggplot(aes(x=count)) + geom_density(aes(color=as.factor(QSCORE),linetype = lengthRef_interval)) + ggtitle( "CAG count with different Qscore, Prefix/Suffix length" )
