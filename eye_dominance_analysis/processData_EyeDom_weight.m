%process data (trials where dominant eye sees high contrast) 
%and save the best fit params as weights for each stim x cond
%for expt 1, combine the different examplers for noise and natural
clear all;
close all;
set(groot,'defaultfigureposition',[100 100 1300 700]);
load('Expt1_subjeyedom.mat');
expt1_eye = expt1_subjeye;

%% Exp1
addpath('../');
addpath('../expt1 data/');
%set up for parameter (weight of high contrast stim)
stepsize = 0.01;
weights = 0:stepsize:1;
%to store result
expt1weights = [];
for s = 1:10
     %which stimulus' data to use for determining eye
     %dominance(1=1cpd,2=5cpd,3=noise,4=natural,5=all stim)
    for eye_stim = 1:5 
        whateye = expt1_eye(expt1_eye(:,1)==s,1+eye_stim);  %look up which eye is dominant for this subj+stimulus
        filename = ['CSCM_',num2str(s+3),'.mat'];
        load(filename);
        
        % with method of adjustment, sometimes Matlab doesn't allow value to be
        % exactly zero. Replace very very small values with 0
        dat.resp(dat.resp(:,1)<1e-15) = 0;
        data0 = [dat.stim dat.resp];

        %categorize trials based on the eye condition
        if whateye ==0 %RE dominant
            dataDE = data0(data0(:,4)<data0(:,5),:); %trials where the dominant eye sees higher contrast
            dataNDE = data0(data0(:,4)>data0(:,5),:); %trials where the nondominant eye sees higher contrast
        elseif whateye ==1 %LE dominant
            dataDE = data0(data0(:,4)>data0(:,5),:); %trials where the dominant eye sees higher contrast
            dataNDE = data0(data0(:,4)<data0(:,5),:); %trials where the nondominant eye sees higher contrast
        end

        %process the data to find the best fit weight for the dominant and
        %nondominant eye
        for eye = 1:2

            if eye ==1 %DE
                data = dataDE;
            elseif eye ==2 %NDE
                data = dataNDE;
            end

            for cond = 1:3 %3 surround conditions
                for stimtype = 1:9 %subset of data for each exemplar
                    if stimtype ==1
                        subdata = data(data(:,1)==1 & data(:,2)==cond & data(:,3)==1,:);
                    elseif stimtype ==2
                        subdata = data(data(:,1)==1 & data(:,2)==cond & data(:,3)==5,:);
                    elseif stimtype ==3
                        subdata = data(data(:,1)==2 & data(:,2)==cond & data(:,3)==1,:);
                    elseif stimtype ==4
                        subdata = data(data(:,1)==2 & data(:,2)==cond & data(:,3)==2,:);
                    elseif stimtype ==5
                        subdata = data(data(:,1)==2 & data(:,2)==cond & data(:,3)==3,:);
                    elseif stimtype ==6
                        subdata = data(data(:,1)==2 & data(:,2)==cond & data(:,3)==4,:);
                    elseif stimtype ==7
                        subdata = data(data(:,1)==3 & data(:,2)==cond & data(:,3)==1,:);
                    elseif stimtype ==8
                        subdata = data(data(:,1)==3 & data(:,2)==cond & data(:,3)==2,:);
                    elseif stimtype ==9
                        subdata = data(data(:,1)==3 & data(:,2)==cond & data(:,3)==3,:);
                    end
                    
                    %fit weight by comparing predicted binocular contrast to human data
                    dataToFit = subdata;
                    if (whateye ==0 && eye ==1) || (whateye ==1 && eye ==2)%LE is low
                        highC = dataToFit(:,5);
                        lowC = dataToFit(:,4);
                    elseif (whateye ==1 && eye ==1) || (whateye ==0 && eye ==2) %LE is high
                        highC = dataToFit(:,4);
                        lowC = dataToFit(:,5);
                    end
                    
                    %generate predicted binocular contrast and compare to
                    %human data
                    ModelPred=genBino(lowC,highC,weights);
                    humandata = dataToFit(:,7);
                    subjdata = ones(size(ModelPred)).*humandata; %repeat human data for multiple cols to calculate RMSE for each model fit
                    diffsq = (subjdata - ModelPred).^2;
                    rmse_matrix = sqrt(mean(diffsq,1));
                    bestW_ind = find(rmse_matrix == min(rmse_matrix));
                    w = weights(bestW_ind);
                    
                    %save as mat for plotting
                    expt1weights = [expt1weights; s, cond, stimtype, w, eye_stim,eye];
                end
            end
            
        end
    end
end

save('Expt1_weights.mat','expt1weights');


%% Expt 2
clear all;
close all;
addpath('../');
addpath('../expt2 data/');

%load eye dominance
load('Expt2_subjeyedom.mat');
expt2_eye = expt2_subjeye;

%parameters
stepsize = 0.01;
weights = 0:stepsize:1;

%to store result
expt2weights = [];

%list of non-outlier subjects
load('expt2subj.mat');
ss = slist';

for s = ss
    %load subject data
    filename = ['BCF_',num2str(s),'.mat'];
    load(filename);
    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 
    data0 = [dat.stim dat.resp];
    
    for eye_stim = 1:9 %%subset of data for each exemplar, 1-8 specific stimulus, 9 = all stim
        %which eye is the dominant eye based on the stim chosen
        whateye = expt2_eye(expt2_eye(:,1)==s,1+eye_stim);
        %categorize trials based on the eye condition
        if whateye ==0
            dataDE = data0(data0(:,3)<data0(:,4),:);
            dataNDE = data0(data0(:,3)>data0(:,4),:);
        elseif whateye ==1
            dataDE = data0(data0(:,3)>data0(:,4),:);
            dataNDE = data0(data0(:,3)<data0(:,4),:);
        end
        
        for eye = 1:2
            if eye ==1
                data = dataDE;
            elseif eye ==2
                data = dataNDE;
            end
            
            for cond = [1 2] %only mean surround and high surround
                if cond ==2  %recode cond 2 as 3 for high surround to match up with next steps in the analysis
                    cc = 3;
                else
                    cc = 1;
                end
                
                for stim_ind = 1:8 %which stimulus to use
                    subdata = data(data(:,1)==stim_ind & data(:,2)==cond,:);
                    if (whateye ==0 && eye ==1) || (whateye ==1 && eye ==2)%LE is low
                        highC = subdata(:,4);
                        lowC = subdata(:,3);
                    elseif (whateye ==1 && eye ==1) || (whateye ==0 && eye ==2) %LE is high
                        highC = subdata(:,3);
                        lowC = subdata(:,4);
                    end
                    
                    %fit weight by comparing predicted binocular contrast to human data
                    ModelPred=genBino(lowC,highC,weights);
                    humandata = subdata(:,6);

                    subjdata = ones(size(ModelPred)).*humandata; %repeat human data for multiple cols
                    diffsq = (subjdata - ModelPred).^2;
                    rmse_matrix = sqrt(mean(diffsq,1));
                    
                    bestW_ind = find(rmse_matrix == min(rmse_matrix));
                    w = weights(bestW_ind);
                    
                    expt2weights = [expt2weights; s, cc, stim_ind, w, eye_stim,eye];
                    

                end
            end
        end
    end
    
end
    
save('Expt2_weights.mat','expt2weights');
