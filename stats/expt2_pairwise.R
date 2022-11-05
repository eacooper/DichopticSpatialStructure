#do pairwise comparison (wilcoxin sign rank) for the conditions of interest 

library(exactRankTests)

#load the raw weights data
expt_all <- read.csv(file = 'WeightData.csv',header=TRUE)
expt2 <-expt_all[(expt_all$Expt==2),]
expt2 <- expt2[(expt2$StimName!="G5_horz" & expt2$StimName!="G5_blur" & expt2$StimName!="No4_blur"),] #remove the horz grating/blur conditions

expt<-expt2

# get the conditions
MS_grat <- expt$FitParam[(expt$CondCombo=="MS_G5")]
HS_grat <- expt$FitParam[(expt$CondCombo=="HS_G5")]
MS_noise <- expt$FitParam[(expt$CondCombo=="MS_No4")]
HS_noise <- expt$FitParam[(expt$CondCombo=="HS_No4")]

MS_histeq <- expt$FitParam[(expt$CondCombo=="MS_No4_histeq")]
HS_histeq <- expt$FitParam[(expt$CondCombo=="HS_No4_histeq")]
MS_bandpass <- expt$FitParam[(expt$CondCombo=="MS_No4_bandpass")]
HS_bandpass <- expt$FitParam[(expt$CondCombo=="HS_No4_bandpass")]
MS_broadband <- expt$FitParam[(expt$CondCombo=="MS_No4_bar")]
HS_broadband <- expt$FitParam[(expt$CondCombo=="HS_No4_bar")]

#create a data frame to store the stats
df <- data.frame(matrix(ncol = 3, nrow = 0))
#provide column names
colnames(df) <- c('pairname', 'test stat','p')

######### compare between surround conditions for each stimuli  #########
result <-wilcox.exact(MS_grat, HS_grat, paired=TRUE) 
df[1,] <-c('MS_grat-HS_grat',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_noise, HS_noise, paired=TRUE) 
df[2,] <-c('MS_noise-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_histeq, HS_histeq, paired=TRUE) 
df[3,] <-c('MS_histeq-HS_histeq',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_bandpass, HS_bandpass, paired=TRUE) 
df[4,] <-c('MS_bandpass-HS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_broadband, HS_broadband, paired=TRUE) 
df[5,] <-c('MS_broadband-HS_broadband',result[["statistic"]][["V"]],result[["p.value"]])

#create a data frame to store the stats
df2 <- data.frame(matrix(ncol = 3, nrow = 0))
#provide column names
colnames(df2) <- c('pairname', 'test stat','p')

######### compare between different stim for each surround #########
result <-wilcox.exact(MS_grat, MS_noise, paired=TRUE) 
df2[1,] <-c('MS_grat-MS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_grat, MS_histeq, paired=TRUE) 
df2[2,] <-c('MS_grat-MS_histeq',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_grat, MS_bandpass, paired=TRUE) 
df2[3,] <-c('MS_grat-MS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_grat, MS_broadband, paired=TRUE) 
df2[4,] <-c('MS_grat-MS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(MS_noise, MS_histeq, paired=TRUE) 
df2[5,] <-c('MS_noise-MS_histeq',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_noise, MS_bandpass, paired=TRUE) 
df2[6,] <-c('MS_noise-MS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_noise, MS_broadband, paired=TRUE) 
df2[7,] <-c('MS_noise-MS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(MS_histeq, MS_bandpass, paired=TRUE) 
df2[8,] <-c('MS_histeq-MS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_histeq, MS_broadband, paired=TRUE) 
df2[9,] <-c('MS_histeq-MS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_bandpass, MS_broadband, paired=TRUE) 
df2[10,] <-c('MS_bandpass-MS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
############
result <-wilcox.exact(HS_grat, HS_noise, paired=TRUE) 
df2[11,] <-c('HS_grat-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_grat, HS_histeq, paired=TRUE) 
df2[12,] <-c('HS_grat-HS_histeq',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_grat, HS_bandpass, paired=TRUE) 
df2[13,] <-c('HS_grat-HS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_grat, HS_broadband, paired=TRUE) 
df2[14,] <-c('HS_grat-HS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(HS_noise, HS_histeq, paired=TRUE) 
df2[15,] <-c('HS_noise-HS_histeq',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_noise, HS_bandpass, paired=TRUE) 
df2[16,] <-c('HS_noise-HS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_noise, HS_broadband, paired=TRUE) 
df2[17,] <-c('HS_noise-HS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(HS_histeq, HS_bandpass, paired=TRUE) 
df2[18,] <-c('HS_histeq-HS_bandpass',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_histeq, HS_broadband, paired=TRUE) 
df2[19,] <-c('HS_histeq-HS_broadband',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_bandpass, HS_broadband, paired=TRUE) 
df2[20,] <-c('HS_bandpass-HS_broadband',result[["statistic"]][["V"]],result[["p.value"]])

#save result as CSV to manually apply Bonferroni correction 
write.csv(df,"expt2_signrank_surround.csv", row.names = TRUE)
write.csv(df2,"expt2_signrank_stim.csv", row.names = TRUE)
