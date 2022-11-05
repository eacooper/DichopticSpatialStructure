% look at the data along the identity diagonal (nondichoptic reference) to
% see how much error is made by the observer, and categorize
% outlier/non-outlier based on the exclusion criteria

clear all;
addpath('./expt1 data/');
addpath('./expt2 data/');

%Experiment 1
subjID = [4 5 6 7 8 9 10 11 12 13]; % subject IDs -- 1-3 were pilot subjects
nsubj = size(subjID,2);

errorlist = [];

for s = 1:nsubj 

    subj = subjID(s);
    datafile = ['CSCM_' num2str(subj) '.mat'];
    load(datafile);

    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 

    % concatenate stimulus and response info
    data = [dat.stim dat.resp];
    
    %find the trials along the diagonals, i.e. LE contrast = RE contrast
    %do it for each condition, then find the standard deviation of the
    %errors
    
    subdata = data(data(:,4)==data(:,5),:);

    diff = subdata(:,7) - subdata(:,6); %difference between resp and the expected correct answer
    errorval = sqrt(mean(diff.^2)); %root mean squared error of the difference
    errorlist = [errorlist; s errorval];
    
end

medianval = prctile(errorlist(:,2),50); %median of error
p75 = prctile(errorlist(:,2),75);
p25 = prctile(errorlist(:,2),25);
IQRval =  p75 - p25; %interquantile range

figure(10);
hold on;
%outlier criteria = 1.5 x IQR above and below the 25th and 75th quartile
plot([1 1],[p25-1.5*IQRval, p75+1.5*IQRval],'b','LineWidth',2);
plot(1,medianval,'bo','MarkerSize',12);
plot(ones(1,10)+0.1*(rand([1 10])-0.5),errorlist(:,2),'k.','MarkerSize',12);
title('error range');

%% data from the followup study, Experiment 2

% subject list
allsubj = 1:35; 
allsubj(19) = []; %remove subj that didn't finish the experiment
N = size(allsubj,2);

errorlist2 = [];

for s = allsubj

    datafile = ['BCF_' num2str(s) '.mat'];
    load(datafile);

    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 

    % concatenate stimulus and response info
    data = [dat.stim, dat.resp(:,1)];

    %find the trials along the diagonals, i.e. LE contrast = RE contrast
    %do it for each condition, then find the standard deviation across
    
    subdata = data(data(:,3)==data(:,4),:);
    diff = subdata(:,6) - subdata(:,5); %difference between resp and the expected correct answer (can just do resp - surround contrast which is equal to the two center contrasts)
    errorval2 = sqrt(mean(diff.^2));
    errorlist2 = [errorlist2; s errorval2];
end


medianval2 = prctile(errorlist2(:,2),50);
p75_2 = prctile(errorlist2(:,2),75);
p25_2 = prctile(errorlist2(:,2),25);
IQRval2 =  p75_2 - p25_2; %interquantile range

figure(10);
hold on;
%outlier criteria = 1.5 x IQR above and below the 25th and 75th quartile
plot([2 2],[p25_2-1.5*IQRval2, p75_2+1.5*IQRval2],'b','LineWidth',2);
plot(2,medianval2,'bo','MarkerSize',12);
plot(ones(1,N)+1+0.1*(rand([1 N])-0.5),errorlist2(:,2),'k.','MarkerSize',12);

%check
B = rmoutliers(errorlist2(:,2),'quartiles');

%remove the outliers and save the list of subjects
subjlist = errorlist2;
subjlist(subjlist(:,2)>(1.5*IQRval2+p75_2),:) = [];
slist = subjlist(:,1);
save('expt2subj.mat','slist');



