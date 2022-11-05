#do pairwise comparison (wilcoxin sign rank) for the conditions of interest 

library(exactRankTests)

#load the raw weights data
expt_all <- read.csv(file = 'WeightData.csv',header=TRUE)
expt1 <-expt_all[(expt_all$Expt==1),]

expt<-expt1

# get the conditions
MS_1cpd <- expt$FitParam[(expt$CondCombo=="MS_1cpd")]
LS_1cpd <- expt$FitParam[(expt$CondCombo=="LS_1cpd")]
HS_1cpd <- expt$FitParam[(expt$CondCombo=="HS_1cpd")]

MS_5cpd <- expt$FitParam[(expt$CondCombo=="MS_5cpd")]
LS_5cpd <- expt$FitParam[(expt$CondCombo=="LS_5cpd")]
HS_5cpd <- expt$FitParam[(expt$CondCombo=="HS_5cpd")]

MS_noise <- expt$FitParam[(expt$CondCombo=="MS_noise")]
LS_noise <- expt$FitParam[(expt$CondCombo=="LS_noise")]
HS_noise <- expt$FitParam[(expt$CondCombo=="HS_noise")]

MS_natural <- expt$FitParam[(expt$CondCombo=="MS_natural")]
LS_natural <- expt$FitParam[(expt$CondCombo=="LS_natural")]
HS_natural <- expt$FitParam[(expt$CondCombo=="HS_natural")]

#create a data frame to store the stats
df <- data.frame(matrix(ncol = 3, nrow = 0))
#provide column names
colnames(df) <- c('pairname', 'test stat','p')

######### compare between surround conditions for each stimuli  #########
result <-wilcox.exact(MS_1cpd, LS_1cpd, paired=TRUE) 
df[1,] <-c('MS_1cpd - LS_1cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_1cpd, HS_1cpd, paired=TRUE) 
df[2,] <-c('MS_1cpd-HS_1cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_1cpd, HS_1cpd, paired=TRUE) 
df[3,] <-c('LS_1cpd-HS_1cpd',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(MS_5cpd, LS_5cpd, paired=TRUE) 
df[4,] <-c('MS_5cpd - LS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_5cpd, HS_5cpd, paired=TRUE) 
df[5,] <-c('MS_5cpd-HS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_5cpd, HS_5cpd, paired=TRUE) 
df[6,] <-c('LS_5cpd-HS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(MS_noise, LS_noise, paired=TRUE) 
df[7,] <-c('MS_noise - LS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_noise, HS_noise, paired=TRUE) 
df[8,] <-c('MS_noise-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_noise, HS_noise, paired=TRUE) 
df[9,] <-c('LS_noise-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(MS_natural, LS_natural, paired=TRUE) 
df[10,] <-c('MS_natural - LS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_natural, HS_natural, paired=TRUE) 
df[11,] <-c('MS_natural-HS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_natural, HS_natural, paired=TRUE) 
df[12,] <-c('LS_natural-HS_natural',result[["statistic"]][["V"]],result[["p.value"]])

#create a data frame to store the stats
df2 <- data.frame(matrix(ncol = 3, nrow = 0))
#provide column names
colnames(df2) <- c('pairname', 'test stat','p')
######### compare between different stim for each surround #########
result <-wilcox.exact(MS_1cpd, MS_5cpd, paired=TRUE) 
df2[1,] <-c('MS_1cpd-MS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_1cpd, MS_noise, paired=TRUE) 
df2[2,] <-c('MS_1cpd-MS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_1cpd, MS_natural, paired=TRUE) 
df2[3,] <-c('MS_1cpd-MS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_5cpd, MS_noise, paired=TRUE) 
df2[4,] <-c('MS_5cpd-MS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_5cpd, MS_natural, paired=TRUE) 
df2[5,] <-c('MS_5cpd-MS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(MS_noise, MS_natural, paired=TRUE) 
df2[6,] <-c('MS_noise-MS_natural',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(LS_1cpd, LS_5cpd, paired=TRUE) 
df2[7,] <-c('LS_1cpd-LS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_1cpd, LS_noise, paired=TRUE) 
df2[8,] <-c('LS_1cpd-LS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_1cpd, LS_natural, paired=TRUE) 
df2[9,] <-c('LS_1cpd-LS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_5cpd, LS_noise, paired=TRUE) 
df2[10,] <-c('LS_5cpd-LS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_5cpd, LS_natural, paired=TRUE) 
df2[11,] <-c('LS_5cpd-LS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(LS_noise, LS_natural, paired=TRUE) 
df2[12,] <-c('LS_noise-LS_natural',result[["statistic"]][["V"]],result[["p.value"]])
###
result <-wilcox.exact(HS_1cpd, HS_5cpd, paired=TRUE) 
df2[13,] <-c('HS_1cpd-HS_5cpd',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_1cpd, HS_noise, paired=TRUE) 
df2[14,] <-c('HS_1cpd-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_1cpd, HS_natural, paired=TRUE) 
df2[15,] <-c('HS_1cpd-HS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_5cpd, HS_noise, paired=TRUE) 
df2[16,] <-c('HS_5cpd-HS_noise',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_5cpd, HS_natural, paired=TRUE) 
df2[17,] <-c('HS_5cpd-HS_natural',result[["statistic"]][["V"]],result[["p.value"]])
result <-wilcox.exact(HS_noise, HS_natural, paired=TRUE) 
df2[18,] <-c('HS_noise-HS_natural',result[["statistic"]][["V"]],result[["p.value"]])

## save result as CSV to manually apply Bonferroni correction 
write.csv(df,"expt1_signrank_surround.csv", row.names = TRUE)
write.csv(df2,"expt1_signrank_stim.csv", row.names = TRUE)

