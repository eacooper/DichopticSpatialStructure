%process all the data and save the best fit params as Tables for each
%stim/subj 
clear all;


%% Experiment 1
addpath('./expt1 data/');

%set up for parameter values to do a grid search (weight of high contrast stim)
stepsize    = 0.01;
weights     = 0:stepsize:1;
stimEx      = {[1 5],[1 2 3 4],[1 2 3]}; %exemplars: grating(1,5), noise(1-4), natural (1-3)
ctxt        = {'MS','LS','HS'}; %surrounds: meanS, lowS, highS
stimname    = {'G1','G5','Noise1','Noise2','Noise3','Noise4','Natural1','Natural2','Natural3'};

% initialize matrix to store results of weights
expt1weights = [];
subjID = [4 5 6 7 8 9 10 11 12 13]; % subject IDs -- 1-3 were pilot subjects

% for each subject
for s = 1:10
    
    %load data
    filename = ['CSCM_',num2str(subjID(s)),'.mat'];
    load(filename);

    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 
    data = [dat.stim dat.resp];
    
    %preprocessing and get the subset of data to do the fitting
    for cond = 1:3 %the three different surround conditions
        for stimtype = 1:9 %recode to #1-9
            if stimtype ==1 %1cpd
                dataToFit = data(data(:,2)==cond & data(:,1)==1 & data(:,3)==1,:);
            elseif stimtype ==2 %5cpd
                dataToFit = data(data(:,2)==cond & data(:,1)==1 & data(:,3)==5,:);
            elseif stimtype ==3 %noise1
                dataToFit = data(data(:,2)==cond & data(:,1)==2 & data(:,3)==1,:);
            elseif stimtype ==4 %noise2
                dataToFit = data(data(:,2)==cond & data(:,1)==2 & data(:,3)==2,:);
            elseif stimtype ==5 %noise3
                dataToFit = data(data(:,2)==cond & data(:,1)==2 & data(:,3)==3,:);
            elseif stimtype ==6 %noise4
                dataToFit = data(data(:,2)==cond & data(:,1)==2 & data(:,3)==4,:);
            elseif stimtype ==7 %natural1
                dataToFit = data(data(:,2)==cond & data(:,1)==3 & data(:,3)==1,:);
            elseif stimtype ==8 %natural2
                dataToFit = data(data(:,2)==cond & data(:,1)==3 & data(:,3)==2,:);
            elseif stimtype ==9 %natural3
                dataToFit = data(data(:,2)==cond & data(:,1)==3 & data(:,3)==3,:);
            end

            %get the dichoptic trials (exclude the catch trials with
            %non-dichoptic reference)
            dataToFit = dataToFit(dataToFit(:,4)~=dataToFit(:,5),:);

            %the two eye's contrasts
            dataToFitlow = min(dataToFit(:,4:5),[],2);
            dataToFithigh = max(dataToFit(:,4:5),[],2);

            %give the high and low contrasts, along with the list of
            %weights to search to generate model predictions for each stimulus/possible weighting
            ModelPred=genBino(dataToFitlow,dataToFithigh,weights);

            % data to calculate RMSE
            humandata = dataToFit(:,7);
            subjdata = ones(size(ModelPred)).*humandata; %repeat human data for multiple cols to calculate RMSE for each model fit

            %compare human data to model results with different weights and find the best weight (minimize RMSE)
            diffsq = (subjdata - ModelPred).^2;
            rmse_matrix = sqrt(mean(diffsq,1));
            minRMSE = min(rmse_matrix);
            bestW_ind = find(rmse_matrix == minRMSE);
            w = weights(bestW_ind);
            
            %store the results
            expt1weights = [expt1weights; s, cond, stimtype, w, minRMSE];
        end
    end
end

save('Expt1_weights.mat','expt1weights');

%% Experiment 2
clear all;
close all;
addpath('./expt2 data/');

stepsize = 0.01;
weights  = 0:stepsize:1;

%load the list of subjects after outlier removal
load('expt2subj.mat');
ss = slist';
expt2weights = [];

for s = ss

    filename = ['BCF_',num2str(s),'.mat'];
    load(filename);

    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 
    data = [dat.stim dat.resp];
    
    for cond = [1 2] %only mean surround and high surround
        for stim_ind = 1:8 %vert grat,horz grat,grat blur,noise,hist eq,bandpass,broadband/1D,noise blur

            %get the subset of data for this condition
            dataToFit= data(data(:,1)==stim_ind & data(:,2)==cond,:);
            dataToFit = dataToFit(dataToFit(:,3)~=dataToFit(:,4),:); % removing conditions with same contrast in both eyes

            dataToFitlow = min(dataToFit(:,3:4),[],2);
            dataToFithigh = max(dataToFit(:,3:4),[],2);

            %do the fitting
            ModelPred=genBino(dataToFitlow,dataToFithigh,weights);

            humandata = dataToFit(:,6);
            subjdata = ones(size(ModelPred)).*humandata; %repeat human data for multiple cols

            %compare to the human data (min. RMSE)
            diffsq = (subjdata - ModelPred).^2;
            rmse_matrix = sqrt(mean(diffsq,1));
            minRMSE = min(rmse_matrix);
            bestW_ind = find(rmse_matrix == minRMSE);
            w = weights(bestW_ind);

            %store the result
            expt2weights = [expt2weights; s, cond, stim_ind, w, minRMSE];
            
        end
    end
end

%save the result for plotting
save('Expt2_weights.mat','expt2weights');

