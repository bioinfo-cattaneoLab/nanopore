library(tidyverse)
library(pastecs)
# library(rlist)
extractp=pastecs::extract

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
# write.table(spike_81Q_50Q_filt,"/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/spike_81Q_50Q_filt.tsv", row.names=F, quote=F, sep="\t")

names(spike_81Q_50Q)[names(spike_81Q_50Q)=="ID"] <- "read_id"

################ Strique plots

spike_81Q_50Q_filt %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count)) + geom_histogram(bins=100) + xlim(0,100)
spike_81Q_50Q_filt %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count)) + geom_histogram(bins=200)

spike_81Q_50Q_filt %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(experiment,count)) + geom_jitter() + ylim(0,100)

################ percent of 81Q / tot
low=spike_81Q_50Q_filt %>% filter(count >0, count < 38, score_prefix > 4, score_suffix > 4)
med=spike_81Q_50Q_filt %>% filter(count >0, count > 38 , count < 71, score_prefix > 4, score_suffix > 4)
high=spike_81Q_50Q_filt %>% filter(count >0, count > 71, score_prefix > 4, score_suffix > 4)

nrow(high)/(nrow(high)+nrow(low)+nrow(med))
################ Find turning points

peakStrique =spike_81Q_50Q_filt %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

#[https://rdrr.io/cran/pastecs/man/turnpoints.html]

library(pastecs)

plot(peakStrique$n, type = "l")
# Calculate turning points for this series
strique.tp <- turnpoints(peakStrique$n)
summary(strique.tp)
plot(strique.tp)
# Add envelope and median line to original data
plot(peakStrique$n, type = "l")
lines(strique.tp)
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")

################ NeoR

spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')

spike_81Q_50Q_neo = spike_81Q_50Q_neo %>% filter(alignment_coverage != "-1")

final_dataframe = merge(spike_81Q_50Q_neo , spike_81Q_50Q, by=c("read_id"))

final_dataframe$NEO_filter = "yes"
spike_81Q_50Q$NEO_filter = "no"
neo=final_dataframe %>% select(read_id,count,score_prefix,score_suffix,NEO_filter)
noNeo=spike_81Q_50Q %>% select(read_id,count,score_prefix,score_suffix,NEO_filter)

test=rbind(neo,noNeo)
test_filt = test %>% group_by(read_id) %>% filter(n()==1)

test %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count, fill=NEO_filter)) + geom_histogram(bins=100) + xlim(0,100) + facet_grid(  NEO_filter ~.) + xlab("CAG count") + ylab("Reads count") + theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1, size = 10),axis.title.x = element_text(size=15),axis.title.y = element_text(size=15))
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_NEOfilter.png")
test %>% filter(count >0, score_prefix > 4, score_suffix > 4, NEO_filter == "yes") %>% ggplot(aes(count, fill=NEO_filter)) + geom_histogram(bins=100, fill="#55BCC2") + xlim(0,100) + xlab("CAG count") + ylab("Reads count") + theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust=1, size = 10),axis.title.x = element_text(size=15),axis.title.y = element_text(size=15))
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_NEOfilterYES.png")



final_dataframe %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count)) + geom_histogram()
final_dataframe %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count)) + geom_histogram(bins=100) + xlim(0,100)
final_dataframe %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% ggplot(aes(count)) + geom_histogram(bins=200)


################ percent of 81Q / tot NEO
low=final_dataframe %>% filter(count >0, count < 38, score_prefix > 4, score_suffix > 4)
med=final_dataframe %>% filter(count >0, count > 38 , count < 71, score_prefix > 4, score_suffix > 4)
high=final_dataframe %>% filter(count >0, count > 71, score_prefix > 4, score_suffix > 4)

nrow(high)/(nrow(high)+nrow(low)+nrow(med))

################ Find turning points NEO

peakStrique_neo =final_dataframe %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()

plot(peakStrique_neo$n, type = "l")
# Calculate turning points for this series
strique_neo.tp <- turnpoints(peakStrique_neo$n)
summary(strique_neo.tp)
plot(strique_neo.tp)
# Add envelope and median line to original data
plot(peakStrique_neo$n, type = "l")
lines(strique_neo.tp)
# Note that lines() applies to the graph of original dataset
title("Raw data, envelope maxi., mini. and median lines")

df=data.frame(strique_neo.tp$tppos, strique_neo.tp$proba)
ggplot(df, aes( strique_neo.tp.tppos, -log10(strique_neo.tp.proba))) + geom_line() + geom_point()

################ RepeatHMM

repeatHMM = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/RepeatHMM.tsv",header=T, sep="\t")

plot(repeatHMM$n, type = "l")
# Calculate turning points for this series
repeatHMM.tp <- turnpoints(repeatHMM$n)
summary(repeatHMM.tp)
plot(repeatHMM.tp)
# Add envelope and median line to original data
plot(repeatHMM$n, type = "l")
lines(repeatHMM.tp)

repeatHMM_neo = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/RepeatHMM_neo.tsv",header=T, sep="\t")

plot(repeatHMM_neo$n, type = "l")
# Calculate turning points for this series
repeatHMM_neo.tp <- turnpoints(repeatHMM_neo$n)
summary(repeatHMM_neo.tp)
plot(repeatHMM_neo.tp)
# Add envelope and median line to original data
plot(repeatHMM_neo$n, type = "l")
lines(repeatHMM_neo.tp,max = TRUE, min = TRUE, median = TRUE)

################ investigate short reads without NEO

spike_81Q_50Q %>% filter( count < 40 ) %>% select(read_id) %>% write.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_noNEO.tsv", row.names=F )
final_dataframe %>% filter( count < 40 ) %>% select(read_id) %>% write.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_NEO.tsv", row.names=F )

short_id_noNEO= read.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_noNEO.tsv", header=T)
short_id_NEO= read.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_NEO.tsv", header=T)

id_short_toInvestigate = rbind(short_id_noNEO,short_id_NEO,by = "read_id" )

# id_short_toInvestigate %>% group_by(read_id) %>% filter(n()==1) %>% write.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/id_short_toInvestigate.tsv", row.names=F, quote=F)

temp_id_short_toInvestigate=id_short_toInvestigate %>% group_by(read_id) %>% filter(n()==1)

# alignSummary_spike_81Q_50Q=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary.txt", header=T,sep='\t')
#
# alignSummary_spike_81Q_50Q = alignSummary_spike_81Q_50Q %>% filter(alignment_coverage != "-1")
#
# investigate_reads = merge(temp_id_short_toInvestigate , alignSummary_spike_81Q_50Q, by=c("read_id"))
#
# investigate_reads %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start ')

alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_CRE.txt", header=T, sep="\t")

reads_CRE = merge(temp_id_short_toInvestigate, alignment_CRE, by="read_id")

### short CAG
reads_CRE %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start')

################ CRE site and NeoR

### all reads with different length of CAG
alignment_CRE %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, all Reads and all CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_allCAG.png")


################ all reads, aligned with NeoR

reads_id_NEO = final_dataframe %>% select(read_id)

reads_CRE_NEO = merge(reads_id_NEO, alignment_CRE, by="read_id")

reads_CRE_NEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, all Reads filtered for NeoR')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_NeoFilter.png")

#after this plot we can conclude that there are some reads (2k) with promoter and NeoR but haven't the CRE (LHA) recombinate site

################ long CAG, aligned with NEO

spike_81Q_50Q_noNEO = spike_81Q_50Q_neo %>% filter(alignment_coverage != "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)
# merge CRE alignment file with read_id that haven't NeoR
reads_CRE_noNEO = merge(spike_81Q_50Q_noNEO, alignment_CRE, by="read_id")
# take only read_id with CAG count < 40 (short)
long_id_noNEO= spike_81Q_50Q %>% filter( count > 40 ) %>% select(read_id)
reads_long_CRE_noNEO = merge(long_id_noNEO, reads_CRE_noNEO, by="read_id")

reads_long_CRE_noNEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads filtered for NeoR with long CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_ReadsNeoFilter_longCAG.png")


################ short CAG, aligned with NEO

short_id_NEO= read.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_NEO.tsv", header=T)
short_id_NEO=short_id_NEO %>% group_by(read_id) %>% filter(n()==1)
short_id_NEO_short = merge(short_id_NEO, alignment_CRE, by="read_id")
short_id_NEO_short %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads filtered for NeoR with short CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_ReadsNeoFilter_shortCAG.png")

################ all reads, without NEO filter

reads_id_noNEO_filter= spike_81Q_50Q %>% select(read_id)

reads_CRE_noNEO_filter = merge(reads_id_noNEO_filter, alignment_CRE, by="read_id")

reads_CRE_noNEO_filter %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without filter for NeoR')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeoFilter.png")

################ long CAG without NEO filter

long_id_noNEO= spike_81Q_50Q %>% filter( count > 40 ) %>% select(read_id)
reads_long_CRE_noNEO = merge(long_id_noNEO, alignment_CRE, by="read_id")

reads_long_CRE_noNEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without filter for NeoR with long CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeoFilter_longCAG.png")

################ short CAG without NEO filter

short_id_noNEO= read.table("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/reads_shortCount_noNEO.tsv", header=T)
short_id_noNEO=short_id_noNEO %>% group_by(read_id) %>% filter(n()==1)
reads_CRE_short_noNEOfilter = merge(short_id_noNEO, alignment_CRE, by="read_id")
reads_CRE_short_noNEOfilter %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without filter for NeoR with short CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeoFilter_shortCAG.png")

################ all reads,  without NeoR

spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')

spike_81Q_50Q_neo = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)
reads_CRE_noNEO = merge(spike_81Q_50Q_neo, alignment_CRE, by="read_id")
reads_CRE_noNEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without NeoR')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeo.png")

################ short CAG, reads without NeoR

short_id_noNEO= spike_81Q_50Q %>% filter( count < 40 ) %>% select(read_id)

spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')
# take only read_id that haven't NeoR
spike_81Q_50Q_noNEO = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)
# merge CRE alignment file with read_id that haven't NeoR
reads_CRE_noNEO = merge(spike_81Q_50Q_noNEO, alignment_CRE, by="read_id")
# take only read_id with CAG count < 40 (short)
short_id_noNEO= spike_81Q_50Q %>% filter( count < 40 ) %>% select(read_id)
reads_short_CRE_noNEO = merge(short_id_noNEO, reads_CRE_noNEO, by="read_id")

reads_short_CRE_noNEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without NeoR and with short CAG count')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeo_shortCAG.png")

################ long CAG, reads without NeoR

# take only read_id that haven't NeoR
spike_81Q_50Q_noNEO = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)
# merge CRE alignment file with read_id that haven't NeoR
reads_CRE_noNEO = merge(spike_81Q_50Q_noNEO, alignment_CRE, by="read_id")
# take only read_id with CAG count < 40 (short)
long_id_noNEO= spike_81Q_50Q %>% filter( count > 40 ) %>% select(read_id)
reads_long_CRE_noNEO = merge(long_id_noNEO, reads_CRE_noNEO, by="read_id")

reads_long_CRE_noNEO %>% filter(alignment_genome_start!=-1 )  %>% ggplot( aes(alignment_genome_start)  ) + geom_histogram(bins=100)  +ggtitle('Alignment genome_start, Reads without NeoR and with long CAG counts')
ggsave("~/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/plots/histogram_allReads_noNeo_longCAG.png")

################ Pastecs with different class after alignment (NO NEO)

# spike_81Q_50Q_filt=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/spike_81Q_50Q_filt.tsv", header=T, sep="\t" )

# spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')

# alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_CRE.txt", header=T, sep="\t")

spike_81Q_50Q_neo = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)

reads_CRE_noNEO = merge(spike_81Q_50Q_neo, alignment_CRE, by="read_id")

reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" ) %>% select(read_id) %>% nrow()
#[1] 22338 reads tot, che non hanno NEO ma allineano con CRE+5'utr
reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < 35 ) %>% select(read_id) %>%  nrow()
#[1] 2613 reads che non hanno NEO ma hanno CRE
reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > 35 ) %>% select(read_id) %>%  nrow()
#[1] 19608 reads che non hanno NEO e neanche CRE


id_siCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < 35 ) %>% select(read_id)
id_noCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > 35 ) %>% select(read_id)

count_noCRE_noNEO=merge(id_noCRE_noNEO,spike_81Q_50Q_filt, by="read_id")
# count_noCRE_noNEO %>% nrow()
# [1] 18222
count_siCRE_noNEO=merge(id_siCRE_noNEO,spike_81Q_50Q_filt, by="read_id")
# count_siCRE_noNEO %>% nrow()
# [1] 1510

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

# point type        proba       info
# 1      4  pit 1.000000e-01  3.3219281
# 2      5 peak 6.666667e-01  0.5849625
# 3      6  pit 2.500000e-01  2.0000000
# 4      8 peak 1.000000e-01  3.3219281
# 5     10  pit 1.003690e-11 36.5358950
# 6     23 peak 4.358390e-18 57.6709105
# 7     33  pit 2.296443e-07 22.0540955
# 8     34 peak 6.666667e-01  0.5849625
# 9     35  pit 6.666667e-01  0.5849625
# 10    36 peak 2.500000e-01  2.0000000
# 11    38  pit 2.777778e-02  5.1699250
# 12    42 peak 1.000000e-01  3.3219281
# 13    43  pit 6.666667e-01  0.5849625
# 14    44 peak 6.666667e-01  0.5849625
# 15    45  pit 2.500000e-01  2.0000000
# 16    47 peak 2.777778e-02  5.1699250
# 17    53  pit 1.000000e-01  3.3219281
# 18    54 peak 6.666667e-01  0.5849625
# 19    64  pit 6.666667e-01  0.5849625
# 20    65 peak 2.500000e-01  2.0000000
# 21    67  pit 2.500000e-01  2.0000000
# 22    68 peak 6.666667e-01  0.5849625
# 23    69  pit 6.666667e-01  0.5849625
# 24    70 peak 2.500000e-01  2.0000000
# 25    74  pit 2.500000e-01  2.0000000
# 26    75 peak 6.666667e-01  0.5849625

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
# point type        proba       info
# 1      3  pit 6.666667e-01  0.5849625
# 2      6 peak 6.666667e-01  0.5849625
# 3      8  pit 1.388889e-02  6.1699250
# 4     12 peak 2.777778e-02  5.1699250
# 5     13  pit 6.666667e-02  3.9068906
# 6     16 peak 1.736111e-03  9.1699250
# 7     21  pit 2.777778e-02  5.1699250
# 8     22 peak 6.666667e-01  0.5849625
# 9     23  pit 6.666667e-01  0.5849625
# 10    24 peak 6.666667e-01  0.5849625
# 11    26  pit 4.960317e-06 17.6211361
# 12    35 peak 7.594058e-12 36.9382660
# 13    44  pit 2.254690e-06 18.7586396
# 14    45 peak 6.666667e-01  0.5849625
# 15    47  pit 6.666667e-01  0.5849625
# 16    48 peak 6.666667e-01  0.5849625
# 17    51  pit 6.666667e-01  0.5849625
# 18    52 peak 6.666667e-01  0.5849625
# 19    54  pit 6.666667e-02  3.9068906
# 20    58 peak 1.000000e-01  3.3219281
# 21    59  pit 2.500000e-01  2.0000000
# 22    62 peak 2.500000e-01  2.0000000
# 23    63  pit 6.666667e-01  0.5849625
# 24    65 peak 6.666667e-01  0.5849625
# 25    66  pit 6.666667e-01  0.5849625
# 26    67 peak 2.500000e-01  2.0000000

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
reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < 35 ) %>% select(read_id) %>%  nrow()
#[1] 11447 reads che non hanno NEO ma hanno CRE
reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > 35 ) %>% select(read_id) %>%  nrow()
#[1] 2531 reads che non hanno NEO e neanche CRE


id_siCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < 35 ) %>% select(read_id)
id_noCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > 35 ) %>% select(read_id)

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
# point type        proba       info
# 1      5  pit 2.500000e-01  2.0000000
# 2      9 peak 2.500000e-01  2.0000000
# 3     10  pit 5.010422e-07 20.9285646
# 4     19 peak 7.236691e-11 33.6858789
# 5     26  pit 1.543210e-04 12.6617781
# 6     27 peak 6.666667e-01  0.5849625
# 7     29  pit 6.666667e-01  0.5849625
# 8     30 peak 2.500000e-01  2.0000000
# 9     32  pit 1.000000e-01  3.3219281
# 10    35 peak 2.500000e-01  2.0000000
# 11    36  pit 3.472222e-04 11.4918531
# 12    42 peak 2.967711e-07 21.6841459
# 13    48  pit 1.041667e-03  9.9068906
# 14    49 peak 6.666667e-01  0.5849625
# 15    50  pit 6.666667e-01  0.5849625
# 16    52 peak 6.666667e-01  0.5849625
# 17    57  pit 6.666667e-02  3.9068906
# 18    61 peak 2.777778e-02  5.1699250
# 19    63  pit 1.000000e-01  3.3219281
# 20    65 peak 2.500000e-01  2.0000000
# 21    66  pit 6.666667e-01  0.5849625
# 22    67 peak 2.500000e-01  2.0000000

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
# point type        proba       info
# 1      2  pit 6.666667e-01  0.5849625
# 2      4 peak 6.666667e-01  0.5849625
# 3      5  pit 6.666667e-02  3.9068906
# 4      8 peak 1.000000e-01  3.3219281
# 5      9  pit 6.666667e-02  3.9068906
# 6     12 peak 1.000000e-01  3.3219281
# 7     14  pit 2.500000e-01  2.0000000
# 8     16 peak 2.500000e-01  2.0000000
# 9     17  pit 4.409171e-05 14.4691330
# 10    24 peak 6.151187e-10 30.5984160
# 11    32  pit 6.213321e-14 43.8716288
# 12    43 peak 4.358390e-18 57.6709105
# 13    56  pit 5.567135e-10 30.7423458
# 14    58 peak 2.777778e-02  5.1699250
# 15    61  pit 1.000000e-01  3.3219281
# 16    62 peak 6.666667e-01  0.5849625
# 17    63  pit 2.500000e-01  2.0000000
# 18    67 peak 2.500000e-01  2.0000000
# 19    68  pit 2.380952e-03  8.7142455
# 20    73 peak 1.933033e-12 38.9122708
# 21    94  pit 1.789436e-09 29.0578477
# 22    95 peak 6.666667e-01  0.5849625
# 23    99  pit 6.666667e-01  0.5849625
# 24   100 peak 2.500000e-01  2.0000000
# 25   108  pit 2.500000e-01  2.0000000
# 26   109 peak 6.666667e-01  0.5849625
# 27   114  pit 6.666667e-01  0.5849625
# 28   115 peak 6.666667e-01  0.5849625

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
###
# peaks_siCRE_siNEO %>% filter(count > 106) %>% select(n) %>% tally()

# peaks_siCRE_siNEO %>% filter(count <= peaks_siCRE_siNEO$count[32]) %>% select(n) %>% sum() + peaks_siCRE_siNEO %>% filter(count > peaks_siCRE_siNEO$count[32], count <= peaks_siCRE_siNEO$count[56]) %>% select(n) %>% sum() + peaks_siCRE_siNEO %>% filter(count > peaks_siCRE_siNEO$count[56], count <=peaks_siCRE_siNEO$count[94]) %>% select(n) %>% sum() +peaks_siCRE_siNEO %>% filter(count > 106) %>% select(n) %>% sum()
#
# ################ sum all reads in different category after alignment
#
# 11176+2453+18222+1510
# # [1] 33361

################

# capture.output(summary(peaks_siCRE_siNEO.tp), file = "test_pastecs.txt" )


# df=data.frame(peaks_noCRE_noNEO.tp$tppos, peaks_noCRE_noNEO.tp$proba, peaks_noCRE_noNEO.tp$info)
# df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
# df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
# df = rbind(df_odd,df_even)
# names(df)[names(df)=="peaks_noCRE_noNEO.tp.info"] <- "info"
# names(df)[names(df)=="peaks_noCRE_noNEO.tp.tppos"] <- "tppos"
# names(df)[names(df)=="peaks_noCRE_noNEO.tp.proba"] <- "proba"
# df = arrange(df, tppos)
#
# #df %>% filter(info>5, type == "peak") %>% select(tppos)
#
# ###per prendere il picco subito prima e dopo un picco
# #df$tppos[which(df$tppos == 23 )-1]
# #df$tppos[which(df$tppos == 23 )+1]
# ###
#
# #create data frame with 0 rows and 2 columns
# df_noCRE_noNEO <- data.frame(matrix(ncol = 2, nrow = 0))
#
# #number of turningPoint
# turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)
#
# ###obtain number of reads between two pits
# for ( c in as.numeric(row.names(turningPosition))) {
# 	n_count=peaks_noCRE_noNEO$count[turningPosition$tppos[c]]
# 	n_reads=peaks_noCRE_noNEO %>% filter(count > peaks_noCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])-1]], count < peaks_noCRE_noNEO$count[df$tppos[which(df$tppos == turningPosition$tppos[c])+1]]) %>% select(n) %>% sum()
# 	test=(c(n_count, n_reads))
# 	df_noCRE_noNEO=rbind(df_noCRE_noNEO,test)
# }
# #rename df column
# colnames(df_noCRE_noNEO) <- c('n_CAG_count', 'n_reads')
# df_noCRE_noNEO$alignment = "CRE/NEO"
