%find the number of people who are left eye dominant in the two experiments

clear all;
load('Expt1_subjeyedom.mat');
load('Expt2_subjeyedom.mat');
%0 = RE dominant, 1 = LE dominant
%col 1 = subject id, col 2 - end eye dominant based on each stim + all stim
%in mean surround
expt1_LEdom = expt1_subjeye>0.5;
expt2_LEdom = expt2_subjeye>0.5;
%calculate the proportion of subj who are left eye dom
expt1_LEdom = sum(expt1_LEdom,1)./size(expt1_LEdom,1); %col 3 = 5cpd
expt2_LEdom = sum(expt2_LEdom,1)./size(expt2_LEdom,1); %col 2 = 5cpd

%percentage of LE dom based on 5cpd mean surround
[expt1_LEdom(3), expt2_LEdom(2)]*100
