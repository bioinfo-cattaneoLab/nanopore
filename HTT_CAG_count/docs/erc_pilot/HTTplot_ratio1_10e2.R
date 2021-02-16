
library(tidyverse)
library(modeest)
file='ratio1_10e2_multiple_150-0-q.tsv'

df10=read.csv(file, header=T,sep='\t')

######################## add column short and long

### soglia arbitraria
df10$repeats=ifelse(df10$count<80,"short","long")

plot=ggplot(df10, aes(x=repeats,y=count,fill=repeats))+geom_boxplot() + xlab("Repeats type") + ylab("Number of repeats")#+ ylim(0,200 )
ggsave("HTT_boxplot_1_10e2.png")

######################## subset long

df10_long=df10 %>% filter(repeats=="long")

str(df10_long)

message("long mean:")
mean(df10_long$count)

#### elimino tutti i valori superiori a 200 (possibili errori?)

message("long mean, count< 200:")
mean(subset(df10_long, count<200)$count)

message("long sd:")
sd(df10_long$count)

message("long mean - sd:")
mean(df10_long$count)-sd(df10_long$count)

message("long mean + sd:")
mean(df10_long$count)+sd(df10_long$count)

######################### subset short

df10_short=df10 %>% filter(repeats=="short")

str(df10_short)

message("short mean:")
mean(df10_short$count)

message("short sd:")
sd(df10_short$count)


message("short mean - sd:")
mean(df10_short$count)-sd(df10_short$count)

message("short mean + sd:")
mean(df10_short$count)+sd(df10_short$count)

######################## density plot
message("long moda:")
mlv(df10_long$count, method = "mfv")

message("short moda::")
mlv(df10_short$count, method = "mfv")

ggplot(df10,aes(count)) + geom_density() + xlab("Number of repeats")

ggsave("~/projects/cattaneo/striqueOutput/density_1_10e2.png")
