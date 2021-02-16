library(tidyverse)
library(pastecs)
args<-commandArgs(TRUE)

#README : questa versione conta solo le reads che compongono il picco detectato da PASTECS

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 45Qc21

spike_81Q_50Q=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_45Qc21_p61.qscore10.150_600bp_CAG.a.tsv",header=T, sep="\t")
spike_81Q_50Q$qscore = "10"
spike_81Q_50Q$replicate = "1"
spike_81Q_50Q$experiment = "45Qc21"

for ( c in c("b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u")) {

filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_45Qc21_p61.qscore10.150_600bp_CAG.", c ,".tsv", sep="")
temp_name= read.table(filePath, header=T,sep='\t')
temp_name$qscore = "10"
temp_name$replicate = "1"
temp_name$experiment = "45Qc21"
spike_81Q_50Q = rbind(spike_81Q_50Q, temp_name)

}
#remove duplicate ID's from STRique's output
spike_81Q_50Q_filt = spike_81Q_50Q %>% group_by(ID) %>% filter(n()==1)
#rename ID column for merging with alignment file
names(spike_81Q_50Q_filt)[names(spike_81Q_50Q_filt)=="ID"] <- "read_id"
#load aligment with fasta
alignment=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_45Qc21_p61.txt", header=T,sep='\t')
#filter for reads's start/end according to config file (interval [320-920bp] used by strique for counting CAG, 600bp) with this parameters we expect that reads have correct length for be counted. Is this filter redundant? we have just filtered with STRique. I could use the length starting from CRE and ending after NeoR (130-2800 bp)
reads_complete = alignment %>% filter( alignment_coverage != -1 ) %>% select(read_id) #& alignment_genome_start < 130 & alignment_genome_end > 2000
#take only IDs with good length
reads_filt_complete = merge(reads_complete, spike_81Q_50Q_filt, by="read_id")
#load alignment file (NEO,CRE)
spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_NEO_45Qc21_p61.txt", header=T,sep='\t')

alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_CRE_45Qc21_p61.txt", header=T, sep="\t")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 21Q replicate 1

# spike_81Q_50Q=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/20201013/21Q-CRE-NEO/data/20201013_allSAM_qscore10.rep1.150_600bp_CAG.tsv",header=T, sep="\t")
# spike_81Q_50Q$qscore = "10"
# spike_81Q_50Q$replicate = "1"
# spike_81Q_50Q$experiment = "19CAG"
#
#
# #remove duplicate ID's from STRique's output
# spike_81Q_50Q_filt = spike_81Q_50Q %>% group_by(ID) %>% filter(n()==1)
# #rename ID column for merging with alignment file
# names(spike_81Q_50Q_filt)[names(spike_81Q_50Q_filt)=="ID"] <- "read_id"
# #load alignment file (NEO,CRE)
# spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/summary/alignment_summary_rep1_NEO.txt", header=T,sep='\t')
#
# alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/20201013/alignment/summary/alignment_summary_rep1_CRE.txt", header=T, sep="\t")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SPIKE IN 81Q-50Q

# spike_81Q_50Q=read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.a.tsv",header=T, sep="\t")
# spike_81Q_50Q$qscore = "10"
# spike_81Q_50Q$replicate = "1"
# spike_81Q_50Q$experiment = "81Q-50Q"
#
# for ( c in c("b","c","d","e","f","g","h","i","j","k")) {
#
# filePath=paste("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC_2020_NANOPORE_SPIKE_IN/AC_SPIKE_IN_81Q-50Q_ratio1-100_qscore10.150_600bp_CAG.", c ,".tsv", sep="")
# temp_name= read.table(filePath, header=T,sep='\t')
# temp_name$qscore = "10"
# temp_name$replicate = "1"
# temp_name$experiment = "81Q-50Q"
# spike_81Q_50Q = rbind(spike_81Q_50Q, temp_name)
#
# }
# #remove duplicate ID's from STRique's output
# spike_81Q_50Q_filt = spike_81Q_50Q %>% group_by(ID) %>% filter(n()==1)
# #rename ID column for merging with alignment file
# names(spike_81Q_50Q_filt)[names(spike_81Q_50Q_filt)=="ID"] <- "read_id"
# #load alignment file (NEO,CRE)
# spike_81Q_50Q_neo=read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_NEO.txt", header=T,sep='\t')
#
# alignment_CRE = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC_2020_NANOPORE_SPIKE_IN/alignment/summary/alignment_summary_CRE.txt", header=T, sep="\t")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

spike_81Q_50Q_noNEO = spike_81Q_50Q_neo %>% filter(alignment_coverage == "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)

spike_81Q_50Q_siNEO = spike_81Q_50Q_neo %>% filter(alignment_coverage != "-1") %>% select(read_id) %>% group_by(read_id) %>% filter(n()==1)

reads_CRE_noNEO = merge(spike_81Q_50Q_noNEO, alignment_CRE, by="read_id")

reads_CRE_siNEO = merge(spike_81Q_50Q_siNEO, alignment_CRE, by="read_id")

# reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" ) %>% select(read_id) %>% nrow()
# #[1] 22338 reads tot, che non hanno NEO ma allineano con CRE+5'utr
# reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(35) ) %>% select(read_id) %>%  nrow()
# #[1] 2613 reads che non hanno NEO ma hanno CRE
# reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(35) ) %>% select(read_id) %>%  nrow()
# #[1] 19608 reads che non hanno NEO e neanche CRE
#
# reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" ) %>% select(read_id) %>% nrow()
# #[1] 13989 reads tot, che non hanno NEO ma allineano con CRE+5'utr
# reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
# #[1] 11447 reads che non hanno NEO ma hanno CRE
# reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start > as.numeric(args[1]) ) %>% select(read_id) %>%  nrow()
# #[1] 2531 reads che non hanno NEO e neanche CRE

id_siCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(20)) %>% select(read_id)
id_noCRE_noNEO=reads_CRE_noNEO %>% filter ( alignment_coverage == "-1" | alignment_genome_start >= as.numeric(20)) %>% select(read_id)

id_siCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage != "-1" & alignment_genome_start < as.numeric(20) ) %>% select(read_id)
id_noCRE_siNEO=reads_CRE_siNEO %>% filter ( alignment_coverage == "-1" | alignment_genome_start >= as.numeric(20) ) %>% select(read_id)


count_noCRE_noNEO=merge(id_noCRE_noNEO,reads_filt_complete, by="read_id")
# count_noCRE_noNEO %>% nrow()

count_siCRE_noNEO=merge(id_siCRE_noNEO,reads_filt_complete, by="read_id")
# count_siCRE_noNEO %>% nrow()

count_noCRE_siNEO=merge(id_noCRE_siNEO,reads_filt_complete, by="read_id")
# count_noCRE_siNEO %>% nrow()

count_siCRE_siNEO=merge(id_siCRE_siNEO,reads_filt_complete, by="read_id")
# count_siCRE_siNEO%>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% nrow()



df_to_build<- data.frame(matrix(ncol = 2, nrow = 0))

for ( c in c("noCRE_noNEO","siCRE_noNEO","noCRE_siNEO","siCRE_siNEO")) {

	count=get(paste("count_",c,sep=""))
	#check dimension of alignment category in the loop
	if(dim(count)[1] != 0) {
		#ottenere per ogni CAG count il numero di reads che hanno quel count
		peaks = count %>% filter(count >0, score_prefix > 4, score_suffix > 4) %>% group_by(count) %>% tally()
		#check if peaks is almost X rows
		if(dim(peaks)[1] > 10){
			#calcolo il turning point
			peaks.tp <- turnpoints(peaks$n)
			#obtain a dataframe from turningpoint output with tppos, proba end info value
			df=data.frame(peaks.tp$tppos, peaks.tp$proba, peaks.tp$info)
			#assign at even rows peak's flag and at odd rows pit's flag (the first value in turningpoint output is always a pit)
			ifelse(peaks.tp$firstispeak == T , (df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="pit")), (df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak")))
			# df_even = df %>% filter(row_number() %% 2 == 0) %>% mutate(type="peak") ## Select even rows
			ifelse(peaks.tp$firstispeak == T , (df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="peak")), (df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")))
			# df_odd = df %>% filter(row_number() %% 2 == 1) %>% mutate(type="pit")## Select odd rows
			df = rbind(df_odd,df_even)
			#rename column
			names(df)[names(df)=="peaks.tp.info"] <- "info"
			names(df)[names(df)=="peaks.tp.tppos"] <- "tppos"
			names(df)[names(df)=="peaks.tp.proba"] <- "proba"
			#arrange by numeric order
			df = arrange(df, tppos)
			#filter for row with info > 5 and that are peaks
			turningPosition = df %>% filter(info>5, type == "peak")%>% select(tppos)
			#check if after filter for info > 5 turningPosition is empty
			if(dim(turningPosition)[1] != 0){
				#plots
				filenameTPpng=paste("~/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/peaksTP_",c,".png",sep="")
				png(filenameTPpng, width = 17, height = 17, units="cm", res= 300)
				plot(peaks.tp)
				dev.off()
				filenamepng=paste("~/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/plots/peaks_",c,".png",sep="")
				png(filenamepng, width = 17, height = 17, units="cm", res= 300)
				plot(peaks$n, type = "l")
				# lines(peaks.tp, col = c(4, 4, 2), lty = c(2, 2, 1))
				title("Raw data, envelope maxi., mini. and median lines")
				dev.off()
				for ( num in as.numeric(row.names(turningPosition))) {
					#obtain n_reads of peaks, n_count associated with this peaks and info value associated with
					n_count=peaks$count[turningPosition$tppos[num]]
					n_reads=peaks %>% filter(count == peaks$count[df$tppos[which(df$tppos == turningPosition$tppos[num])]]) %>% select(n) %>% sum()
					info=df %>% filter (tppos==turningPosition$tppos[num]) %>% select(info)
					test=data.frame(n_count, n_reads,c,info)
					df_to_build=rbind(df_to_build,test)
				}
			}
		}
	}
}
#rename df column
colnames(df_to_build) <- c('CAG_count', 'n_reads','alignment')

df_to_build$alignment = ifelse(df_to_build$alignment == "noCRE_noNEO","NA/NA", ifelse(df_to_build$alignment == "siCRE_noNEO","CRE/NA", ifelse(df_to_build$alignment == "noCRE_siNEO","NA/NEO","CRE/NEO")) )

colnames(df_to_build) <- c('CAG_count', 'n_reads','alignment CRE/NEO','-log2(pvalue)')

exp=c(16,20,26,44,49,80)

df_to_build$expected = ifelse(df_to_build$CAG_count %in% exp, "TRUE", "FALSE")

# check dimension of df_to_build and write table with count, n_reads e type of alignment
if(dim(df_to_build)[1] != 0) write.table(df_to_build,"~/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/test_CAG.tsv", quote=F, row.name=F, sep="\t")
