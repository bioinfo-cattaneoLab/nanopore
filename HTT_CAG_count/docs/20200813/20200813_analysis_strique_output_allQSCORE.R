
########################### LOOP for multiple files with different qscore

library(tidyverse)



prefixPlotPath="/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/plots/20200813_allSAM_allqscore_"

final_df=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore_7.tsv",header=T, sep="\t")

final_df$qscore="7"

for ( qscore in c(7.5, 8, 8.5, 9, 9.5, 10)) {

QSCORE= qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore_", QSCORE ,".tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

temp_name$qscore = as.character(qscore)

final_df = rbind(final_df, temp_name)

print(paste("strDF",qscore,sep=""))
str(temp_name)

temp_nameLong=temp_name %>% filter(count > 100)
temp_nameShort=temp_name %>% filter(count < 100 & count > 0)

print(paste("strDFlong",QSCORE,sep=""))
str(temp_nameLong)

print(paste("strDFshort",QSCORE,sep=""))
str(temp_nameShort)

}

final_df %>% filter(count > 0 ) %>% ggplot(aes(x=count, color = qscore)) + geom_density() + ggtitle( "CAG count with different Qscore from basecalling" )

ggsave(paste(prefixPlotPath , QSCORE , "_DENSITY.png" , sep=""))

final_df %>% filter(count > 0 ) %>% ggplot(aes(x=count, color = qscore)) + geom_density() + ggtitle( "CAG count with different Qscore from basecalling" ) + xlim(0,150)

ggsave(paste(prefixPlotPath , QSCORE , "_DENSITY-XLIM-0-150.png" , sep=""))

############## LOOP for summary statistics about COUNT


for ( qscore in c(7, 7.5, 8, 8.5, 9, 9.5, 10)){

QSCORE= qscore

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/data/20200813_allSAM_qscore_", QSCORE ,".tsv", sep="")

prefixPlotPath="/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/plots/20200813_allSAM_qscore_"

df10=read.csv(filePath, header=T ,sep='\t')

#finalDF=df10 %>% filter(count<100 & count >0)

print(summary(df10$count))


}
