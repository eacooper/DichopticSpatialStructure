#this script does permutation ANOVA for the main conditions in Expt 1 and Expt 2

#load packages
library(lmPerm)
library(ez)
library(schoRsch)

#load the raw weights data
expt_all <- read.csv(file = 'WeightData.csv',header=TRUE)
expt1 <-expt_all[(expt_all$Expt==1),]
expt2 <-expt_all[(expt_all$Expt==2),]
expt2 <- expt2[(expt2$StimName!="G5_horz" & expt2$StimName!="G5_blur" & expt2$StimName!="No4_blur"),] #remove the horzgrating/blur conditions

#select which experiment to analyze
expt<-expt2
#expt<-expt1 

#change variables into factors
expt$Subj <- as.factor(x = expt$Subj)
expt$StimName <- as.factor(x = expt$StimName)
expt$Surround <- as.factor(x = expt$Surround) 
expt$CondCombo <-as.factor(x = expt$CondCombo) 

#regular ANOVA to get full results including effect size
print('***Run regular ANOVA')
aov_for_eta <- ezANOVA(data=expt, dv = FitParam, wid = Subj, within = c(Surround,StimName),return_aov = TRUE, detailed = T)
anova_out(aov_for_eta)

#do permutation ANOVA for p values
print('***Perm ANOVA for p value')
model<-aovp(FitParam ~ Surround * StimName+Error(Subj/(StimName*Surround)),data=expt)
print(summary(model))


