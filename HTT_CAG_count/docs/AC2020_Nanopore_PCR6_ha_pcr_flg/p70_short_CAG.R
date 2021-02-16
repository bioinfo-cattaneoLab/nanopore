myd_10 = read.table("/Users/gianlucadamaggio/projects/cattaneo/striqueOutput/AC2020_Nanopore_PCR6_ha_pcr_flg/AC_PCR6_c15_p70_qscore10.150_600bp_CAG.tsv", header=T, sep= "\t")

myd_10 = myd_10 %>% group_by(ID) %>% filter(n()==1)

#myd_10 %>% filter ( count > 0 , score_prefix >6 , score_suffix > 6 , count > 35) %>% write.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/qscore10_RL35.tsv", sep="\t", row.names=F,quote=F)

short_cag = myd_10 %>% filter ( count > 0 , score_prefix > 4 , score_suffix > 4 , count < 37.5)

names(short_cag)[names(short_cag)=="ID"] <- "read_id"

summary_myd_10 = read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_p70_qscore-10.txt", header=T, sep= "\t")

df_short= merge(short_cag, summary_myd_10, by="read_id")

# df_short %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_coverage, color=qscore)  ) + geom_density(aes(linetype = experiment))  +ggtitle('Alignment Coverage for each Qscore value') + facet_grid( experiment ~., scales="free")

df_short %>% filter(alignment_coverage!=-1 )  %>% ggplot( aes(alignment_genome_end)  ) + geom_density()  +ggtitle('Alignment Coverage for each Qscore value')

align_neo=  read.table("/Users/gianlucadamaggio/projects/cattaneo/docs/AC2020_Nanopore_PCR6_ha_pcr_flg/alignment/summary/alignment_summary_p70-NEO_qscore-10.txt", header=T, sep= "\t")

align_neo = align_neo %>% filter(alignment_coverage != -1)

names(align_neo)[names(align_neo)=="read_id"] <- "ID"

align_neo = align_neo %>% group_by(ID) %>% filter(n()==1)

df_align_neo = merge(align_neo, myd_10, by = "ID" )

df_align_neo %>% summarise(mean=mean(count))
#       mean
# 1 48.75462
df_align_neo %>% filter(score_prefix> 6, score_suffix> 6 , count >0 ) %>% ggplot(aes(target,count)) + geom_jitter()

df_align_neo %>% filter(score_prefix> 6, score_suffix> 6 , count >0 ) %>% ggplot(aes(count)) + geom_density()


df_align_neo %>% filter(count < 40, count >0  ) %>% summarise(mean=mean(count))
#       mean
# 1 26.75763
df_align_neo %>% filter(score_prefix> 6, score_suffix> 6 , count >0 ) %>% ggplot(aes(count)) + geom_density() + xlim(0,40)
Warning message:


> df_align_neo %>% filter(count < 40, count >0  ) %>% nrow()
[1] 4427
> df_align_neo %>% filter(count > 40, count >0  ) %>% nrow()
[1] 67957
> nrow(df_align_neo)
[1] 75660
> df_align_neo %>% filter(count > 0) %>% nrow()
[1] 72524
> 4427/67957
[1] 0.06514414

# reads con 25 CAG sono ~ il 6% delle totali


> df_align_neo %>% filter(score_prefix> 5, score_suffix> 5 , count >0 , count > 40) %>% nrow()
[1] 51975
> df_align_neo %>% filter(score_prefix> 5, score_suffix> 5 , count >0 , count < 40) %>% nrow()
[1] 2229
> 2229/51975
[1] 0.042886
