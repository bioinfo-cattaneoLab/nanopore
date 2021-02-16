library(tidyverse)
library(pastecs)
args<-commandArgs(TRUE)


spike_81Q_50Q=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.a.tsv",header=T, sep="\t")

#spike_81Q_50Q = spike_81Q_50Q %>% group_by(ID) %>% filter(n()==1) # voglio eliminare gli ID doppi, rifare usando uniq di bash

spike_81Q_50Q$qscore = "10"
spike_81Q_50Q$replicate = "1"
spike_81Q_50Q$experiment = "81Q-50Q"

for ( c in c("b","c","d","e","f","g","h","i","j","k")) {

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.", c ,".tsv", sep="")

temp_name= read.table(filePath, header=T,sep='\t')

#temp_name = temp_name %>% group_by(ID) %>% filter(n()==1)

temp_name$qscore = "10"
temp_name$replicate = "1"
temp_name$experiment = "81Q-50Q"

spike_81Q_50Q = rbind(spike_81Q_50Q, temp_name)

}

spike_81Q_50Q_filt = spike_81Q_50Q %>% group_by(ID) %>% filter(n()==1)

names(spike_81Q_50Q_filt)[names(spike_81Q_50Q_filt)=="ID"] <- "read_id"

spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')

alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_CRE.txt", header=T, sep="\t")

spike_81Q_50Q_neo = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)

reads_CRE_noNEO = merge(spike_81Q_50Q_neo, alignment_CRE, by="read_id")

reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" ) %>% select(read_id) %>% nrow()
#[1] 22338 reads tot, che non hanno NEO ma allineano con CRE+5'utr
reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
#[1] 2613 reads che non hanno NEO ma hanno CRE
reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
#[1] 19608 reads che non hanno NEO e neanche CRE

id_siCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(args[1]) ) %>% select(read_id)
id_noCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(args[1]) ) %>% select(read_id)

count_noCRE_noNEO=merge(id_noCRE_noNEO,spike_81Q_50Q_filt, by="read_id")
# count_noCRE_noNEO %>% nrow()
# [1] 18222
count_siCRE_noNEO=merge(id_siCRE_noNEO,spike_81Q_50Q_filt, by="read_id")
# count_siCRE_noNEO %>% nrow()
# [1] 1510

################ Pastecs with different class after alignment (no NEO)

peaks_noCRE_noNEO =count_noCRE_noNEO %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

plot(peaks_noCRE_noNEO$n, type = "l")
# Calculate turning points for this series
peaks_noCRE_noNEO.tp <- turnpoints(peaks_noCRE_noNEO$n)
summary(peaks_noCRE_noNEO.tp)
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaksTP_noCRE_noNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_noCRE_noNEO.tp)
dev.off()
# Add envelope and median line to original data
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaks_noCRE_noNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_noCRE_noNEO$n, type = "l")
lines(peaks_noCRE_noNEO.tp, col = c(4, 4, 2), lty = c(2, 2, 1))
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")
dev.off()

df=data.frame(peaks_noCRE_noNEO.tp$tppos, peaks_noCRE_noNEO.tp$proba, peaks_noCRE_noNEO.tp$info)
df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
df = rbind(df_odd,df_even)
names(df)[names(df)=="peaks_noCRE_noNEO.tp.info"] <- "info"
names(df)[names(df)=="peaks_noCRE_noNEO.tp.tppos"] <- "tppos"
names(df)[names(df)=="peaks_noCRE_noNEO.tp.proba"] <- "proba"
df = arrange(df, tppos)

#create data frame with 0 rows and 2 columns
df_noCRE_noNEO <- data.frame(matrix(ncol = 2, nrow = 0))

#number of turningPoint
turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)

###obtain number of reads between two pits
for ( c in as.numeric(row.names(turningPosition))) {
	n_count=peaks_noCRE_noNEO$count[turningPosition$tppos[c]]
	n_reads=peaks_noCRE_noNEO %>% filter(count > peaks_noCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])-1]], count < peaks_noCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])+1]]) %>% select(n) %>% sum()
	test=(c(n_count, n_reads))
	df_noCRE_noNEO=rbind(df_noCRE_noNEO,test)
}
#rename df column
colnames(df_noCRE_noNEO) <- c('n_CAG_count', 'n_reads')
df_noCRE_noNEO$alignment = "NA/NA"

###
peaks_siCRE_noNEO =count_siCRE_noNEO %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

plot(peaks_siCRE_noNEO$n, type = "l")
# Calculate turning points for this series
peaks_siCRE_noNEO.tp <- turnpoints(peaks_siCRE_noNEO$n)
summary(peaks_siCRE_noNEO.tp)
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaksTP_siCRE_noNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_siCRE_noNEO.tp)
dev.off()
# Add envelope and median line to original data
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaks_siCRE_noNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_siCRE_noNEO$n, type = "l")
lines(peaks_siCRE_noNEO.tp, col = c(4, 4, 2), lty = c(2, 2, 1))
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")
dev.off()

df=data.frame(peaks_siCRE_noNEO.tp$tppos, peaks_siCRE_noNEO.tp$proba, peaks_siCRE_noNEO.tp$info)
df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
df = rbind(df_odd,df_even)
names(df)[names(df)=="peaks_siCRE_noNEO.tp.info"] <- "info"
names(df)[names(df)=="peaks_siCRE_noNEO.tp.tppos"] <- "tppos"
names(df)[names(df)=="peaks_siCRE_noNEO.tp.proba"] <- "proba"
df = arrange(df, tppos)

#create data frame with 0 rows and 2 columns
df_siCRE_noNEO <- data.frame(matrix(ncol = 2, nrow = 0))

#number of turningPoint
turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)

###obtain number of reads between two pits
for ( c in as.numeric(row.names(turningPosition))) {
	n_count=peaks_siCRE_noNEO$count[turningPosition$tppos[c]]
	n_reads=peaks_siCRE_noNEO %>% filter(count > peaks_siCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])-1]], count < peaks_siCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])+1]]) %>% select(n) %>% sum()
	test=(c(n_count, n_reads))
	df_siCRE_noNEO=rbind(df_siCRE_noNEO,test)
}
#rename df column
colnames(df_siCRE_noNEO) <- c('n_CAG_count', 'n_reads')
df_siCRE_noNEO$alignment = "CRE/NA"

################ Pastecs with different class after alignment (SI NEO)

spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')

alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_CRE.txt", header=T, sep="\t")


spike_81Q_50Q_neo = spike_81Q_50Q_neo %>% filter(alignment_coverage != "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)

reads_CRE_siNEO = merge(spike_81Q_50Q_neo, alignment_CRE, by="read_id")

reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" ) %>% select(read_id) %>% nrow()
#[1] 13989 reads tot, che non hanno NEO ma allineano con CRE+5'utr
reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
#[1] 11447 reads che non hanno NEO ma hanno CRE
reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
#[1] 2531 reads che non hanno NEO e neanche CRE


id_siCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(args[1]) ) %>% select(read_id)
id_noCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(args[1]) ) %>% select(read_id)

count_noCRE_siNEO=merge(id_noCRE_siNEO,spike_81Q_50Q_filt, by="read_id")
# count_noCRE_siNEO %>% nrow()
# [1] 2453
count_siCRE_siNEO=merge(id_siCRE_siNEO,spike_81Q_50Q_filt, by="read_id")
# count_siCRE_siNEO%>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% nrow()
# [1] 11176

peaks_noCRE_siNEO =count_noCRE_siNEO %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

plot(peaks_noCRE_siNEO$n, type = "l")
# Calculate turning points for this series
peaks_noCRE_siNEO.tp <- turnpoints(peaks_noCRE_siNEO$n)
summary(peaks_noCRE_siNEO.tp)
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaksTP_noCRE_siNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_noCRE_siNEO.tp)
dev.off()
# Add envelope and median line to original data
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaks_noCRE_siNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_noCRE_siNEO$n, type = "l")
lines(peaks_noCRE_siNEO.tp, col = c(4, 4, 2), lty = c(2, 2, 1))
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")
dev.off()

df=data.frame(peaks_noCRE_siNEO.tp$tppos, peaks_noCRE_siNEO.tp$proba, peaks_noCRE_siNEO.tp$info)
df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
df = rbind(df_odd,df_even)
names(df)[names(df)=="peaks_noCRE_siNEO.tp.info"] <- "info"
names(df)[names(df)=="peaks_noCRE_siNEO.tp.tppos"] <- "tppos"
names(df)[names(df)=="peaks_noCRE_siNEO.tp.proba"] <- "proba"
df = arrange(df, tppos)

#create data frame with 0 rows and 2 columns
df_noCRE_siNEO <- data.frame(matrix(ncol = 2, nrow = 0))

#number of turningPoint
turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)

###obtain number of reads between two pits
for ( c in as.numeric(row.names(turningPosition))) {
	n_count=peaks_noCRE_siNEO$count[turningPosition$tppos[c]]
	n_reads=peaks_noCRE_siNEO %>% filter(count > peaks_noCRE_siNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])-1]], count < peaks_noCRE_siNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])+1]]) %>% select(n) %>% sum()
	test=(c(n_count, n_reads))
	df_noCRE_siNEO=rbind(df_noCRE_siNEO,test)
}
#rename df column
colnames(df_noCRE_siNEO) <- c('n_CAG_count', 'n_reads')
df_noCRE_siNEO$alignment = "NA/NEO"

###

peaks_siCRE_siNEO =count_siCRE_siNEO %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

plot(peaks_siCRE_siNEO$n, type = "l")
# Calculate turning points for this series
peaks_siCRE_siNEO.tp <- turnpoints(peaks_siCRE_siNEO$n)
summary(peaks_siCRE_siNEO.tp)
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaksTP_siCRE_siNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_siCRE_siNEO.tp)
dev.off()
# Add envelope and median line to original data
png(filename="~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/plots/peaks_siCRE_siNEO.png", width = 17, height = 17, units="cm", res= 300)
plot(peaks_siCRE_siNEO$n, type = "l")
lines(peaks_siCRE_siNEO.tp, col = c(4, 4, 2), lty = c(2, 2, 1))
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")
dev.off()

df=data.frame(peaks_siCRE_siNEO.tp$tppos, peaks_siCRE_siNEO.tp$proba, peaks_siCRE_siNEO.tp$info)
df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
df = rbind(df_odd,df_even)
names(df)[names(df)=="peaks_siCRE_siNEO.tp.info"] <- "info"
names(df)[names(df)=="peaks_siCRE_siNEO.tp.tppos"] <- "tppos"
names(df)[names(df)=="peaks_siCRE_siNEO.tp.proba"] <- "proba"
df = arrange(df, tppos)

#create data frame with 0 rows and 2 columns
df_siCRE_siNEO <- data.frame(matrix(ncol = 2, nrow = 0))

#number of turningPoint
turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)

###obtain number of reads between two pits
for ( c in as.numeric(row.names(turningPosition))) {
	n_count=peaks_siCRE_siNEO$count[turningPosition$tppos[c]]
	n_reads=peaks_siCRE_siNEO %>% filter(count > peaks_siCRE_siNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])-1]], count < peaks_siCRE_siNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])+1]]) %>% select(n) %>% sum()
	test=(c(n_count, n_reads))
	df_siCRE_siNEO=rbind(df_siCRE_siNEO,test)
}
#rename df column
colnames(df_siCRE_siNEO) <- c('n_CAG_count', 'n_reads')
df_siCRE_siNEO$alignment = "CRE/NEO"

###

df_experiment_final=rbind(df_siCRE_siNEO,df_noCRE_noNEO,df_siCRE_noNEO,df_noCRE_siNEO)
write.table(df_experiment_final,"~/test_CAG.tsv", quote=F, row.name=F,sep="\t")
