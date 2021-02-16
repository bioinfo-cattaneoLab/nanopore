library(tidyverse)

df10=read.csv("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813/pUC57-Cre/all_reads_200-20b.tsv", header=T,sep='\t')

ggplot(df10, aes(x=count)) + geom_density()

ggsave("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813_pUC57-Cre_density_200-20b.png")

ggplot(df10, aes(x=count)) + geom_density() + xlim(0,150)

ggsave("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813_pUC57-Cre_density_200-20b_xlim0-150.png")

ggplot(df10, aes(x=count)) + geom_density() + xlim(1,150)

ggsave("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813_pUC57-Cre_density_200-20b_xlim1-150.png")


ggplot(df10, aes(x=target, y=count))+geom_boxplot()+ ylim(0,200 )

ggsave("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813_pUC57-Cre_boxplot_200-20b.png")

ggplot(df10, aes(x=count)) + geom_bar() + xlim(1,150) 

ggsave("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20200813_pUC57-Cre_barplot_200-20b_.png")


print("mean count")
mean(df10$count)

print("sd")
sd(df10$count)

print("mean - sd")
mean(df10$count)-sd(df10$count)

print("mean + sd")
mean(df10$count)+sd(df10$count)
