#this script does permutation ANOVA for Expt 2 horizontal grating and edge blur conditions

#load packages
library(lmPerm)
library(ez)
library(schoRsch) 

#load the raw weights data
expt_all <- read.csv(file = 'WeightData.csv',header=TRUE)
expt2 <-expt_all[(expt_all$Expt==2),]

####################   Horizontal grating  #####################

expt2_horz <- expt2[(expt2$StimName=="G5" | expt2$StimName=="G5_horz"),] #compare horz vs. vert gratings

#change to factors
expt2_horz$Subj <- as.factor(x = expt2_horz$Subj)
expt2_horz$StimName <- as.factor(x = expt2_horz$StimName) 
expt2_horz$Surround <- as.factor(x = expt2_horz$Surround)

#regular ANOVA to get full results including effect size
print('***horizontal vs vertical grating')
print('***Run regular ANOVA')
aov_for_eta <- ezANOVA(data=expt2_horz, dv = FitParam, wid = Subj, within = c(Surround,StimName),return_aov = TRUE, detailed = T)
anova_out(aov_for_eta)

#do permutation ANOVA for p values
print('***Perm ANOVA for p value')
model<-aovp(FitParam ~ Surround * StimName+Error(Subj/(StimName*Surround)),data=expt2_horz)
print(summary(model))
####################   Blur   #####################

#get the baseline and baseline blurred conditions
expt2blur <- expt2[(expt2$StimName=="G5" | expt2$StimName=="G5_blur" | expt2$StimName=="No4" | expt2$StimName=="No4_blur"),] 

#let's make another column for blur vs. no blur and recode stim to G5 and No4
expt2recode <- expt2blur

expt2recode$blur[expt2blur$StimName=="No4" | expt2blur$StimName=="G5"]= 'no blur'
expt2recode$blur[expt2blur$StimName=="No4_blur" | expt2blur$StimName=="G5_blur"]= 'blur'
expt2recode$stim2[expt2recode$StimName=="G5_blur" | expt2recode$StimName=="G5"]= 'grating'
expt2recode$stim2[expt2recode$StimName=="No4_blur" | expt2recode$StimName=="No4"]= 'noise'

#change to factors
expt2recode$Subj <- as.factor(x = expt2recode$Subj)
expt2recode$stim2 <- as.factor(x = expt2recode$stim2)
expt2recode$Surround <- as.factor(x = expt2recode$Surround)
expt2recode$blur <-as.factor(x=expt2recode$blur)

print('***Blur')
print('***Run regular ANOVA')
aov_for_eta <- ezANOVA(data=expt2recode, dv = FitParam, wid = Subj, within = c(Surround,stim2,blur),return_aov = TRUE, detailed = T)
anova_out(aov_for_eta)

#do permutation ANOVA for p values
print('***Perm ANOVA for p value')
model<-aovp(FitParam ~ Surround * stim2 * blur+Error(Subj/(stim2*Surround*blur)),data=expt2recode)
print(summary(model))

#separating out grating and noise for follow up analysis on interaction
# comment out one block or the other to look at effect of blur for either gratings or noise
expt2_gratblur <- expt2[(expt2$StimName=="G5" | expt2$StimName=="G5_blur"),] 
expt <- expt2_gratblur

#expt2_noiseblur <- expt2[(expt2$StimName=="No4" | expt2$StimName=="No4_blur"),]
#expt <- expt2_noiseblur


#change to factors
expt$Subj <- as.factor(x = expt$Subj)
expt$StimName <- as.factor(x = expt$StimName) 
expt$Surround <- as.factor(x = expt$Surround) 

print('***Blur for just grating or just noise')
print('***Run regular ANOVA')
aov_for_eta <- ezANOVA(data=expt, dv = FitParam, wid = Subj, within = c(Surround,StimName),return_aov = TRUE, detailed = T)
anova_out(aov_for_eta)

#do perm ANOVA to get p value
print('***Perm ANOVA for p value')
model<-aovp(FitParam ~ Surround * StimName+Error(Subj/(StimName*Surround)),data=expt)
print(summary(model))



