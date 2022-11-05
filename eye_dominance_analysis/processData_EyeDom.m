%process all the data against the winner-take-all template to determine each subj's eye
%dominance

%% Exp1 calculate the rmse
clear all;
addpath('../');
addpath('../expt1 data');

%exemplars: grating(1,5), noise(1-4), natural (1-3)
%surrounds: meanS, lowS, highS
stimEx = {[1 5],[1 2 3 4],[1 2 3]};
ctxt = {'MS','LS','HS'};
stimname = {'G1','G5','Noise','Natural'};
contrasts = [0 0.25 0.5 0.75 1];

%store subj+stim info
Subj = {};
Surround = {};
StimName = {};

%store RMSE between human data the three template (Win, Avg, Los) when the
%LE is seeing low or high contrast
Win_LElow = [];
Avg_LElow = [];
Los_LElow = [];
Win_LEhigh = [];
Avg_LEhigh = [];
Los_LEhigh = [];

subjID = [4 5 6 7 8 9 10 11 12 13]; % subject IDs -- 1-3 were pilot subjects

for s = 1:10
    filename = ['CSCM_',num2str(subjID(s)),'.mat'];
    load(filename);
    
    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 
    data = [dat.stim dat.resp];
    
    %store subset of data when LE is seeing low vs. high contrast
    newdata_LElow = [];
    newdata_LEhigh = [];
    
    %preprocessing
    for cond = 1:3 %3 surround conditions

        for stimtype = 1:3 %3 types of stims (grating, noise, natural)

            if stimtype~=1
                stim_data = []; %for noise and natural, when combining exemplars
            end

            %get the LE/RE and RE/LE separated
            for ex = stimEx{stimtype}

                subdata = data(data(:,1)==stimtype & data(:,2)==cond & data(:,3)==ex,:);
                data_LElowC = [];
                data_LEhighC = [];

                %separate out trials where LE C > RE C and LE C < RE C
                for ii = 1:size(contrasts,2)
                    for jj = 1:size(contrasts,2)

                        LE = contrasts(ii);
                        RE = contrasts(jj);
                        ind = find(subdata(:,4)==LE & subdata(:,5)==RE);
                        
                        if LE<RE
                            data_LElowC = [data_LElowC ; subdata(ind,:)];
                        elseif LE>RE
                            data_LEhighC = [data_LEhighC ; subdata(ind,:)];
                        end
                    end
                end
                
                if stimtype~=1 %for noise and natural exemplars, we store these in a temporary structure that we will loop through again to compute averages
                    stim_data = [stim_data; data_LElowC;data_LEhighC];
                else %for the gratings, we're done because we don't need to average; keep 5cpd and 1cpd separate
                    newdata_LElow = [newdata_LElow; data_LElowC];
                    newdata_LEhigh = [newdata_LEhigh; data_LEhighC];
                end
            end
            
            % get the averages across the different examplers of noise/natural and separate by eye
            if stimtype~=1

                % separate out trials where LE C > RE C and LE C < RE C
                for ii = 1:size(contrasts,2)
                    for jj = 1:size(contrasts,2)

                        LE = contrasts(ii);
                        RE = contrasts(jj);

                        ind = find(stim_data(:,4)==LE & stim_data(:,5)==RE);

                        thisdata = stim_data(ind,:);
                        avgdata = mean(thisdata,1); %average the different exemplars

                        %add the average to the list with the grating data
                        if LE<RE %left eye is seeing lower contrast
                            newdata_LElow = [newdata_LElow ; avgdata];
                        elseif LE>RE %left eye is seeing higher contrast
                            newdata_LEhigh = [newdata_LEhigh ; avgdata];
                        end
                    end
                end

            end
        end
    end
    
    %add the template responses as separate columns
    newdata_LElow(:,8) = max(newdata_LElow(:,4:5),[],2); %winner-take-all
    newdata_LElow(:,9) = mean(newdata_LElow(:,4:5),2); %averaging
    newdata_LElow(:,10) = min(newdata_LElow(:,4:5),[],2); %loser-take-all
    
    newdata_LEhigh(:,8) = max(newdata_LEhigh(:,4:5),[],2); %winner-take-all
    newdata_LEhigh(:,9) = mean(newdata_LEhigh(:,4:5),2); %averaging
    newdata_LEhigh(:,10) = min(newdata_LEhigh(:,4:5),[],2); %loser-take-all
    
    %calculate the root-mean-squared-error (RMSE) for data + template
    for cond = 1:3
        for stim_ind = 1:4  %1cpd, 5cpd, noise, natural
            for eyedata = 1:2 %which set of data (LElow or LEhigh)

                if eyedata ==1
                    dataToFit = newdata_LElow;
                elseif eyedata ==2
                    dataToFit = newdata_LEhigh;
                end

                %select the subset of stimulus data
                if stim_ind ==1
                    data0 = dataToFit(dataToFit(:,1)==1 & dataToFit(:,2)==cond & dataToFit(:,3)==1,:);
                elseif stim_ind ==2
                    data0 = dataToFit(dataToFit(:,1)==1 & dataToFit(:,2)==cond & dataToFit(:,3)==5,:);
                elseif stim_ind ==3
                    data0 = dataToFit(dataToFit(:,1)==2 & dataToFit(:,2)==cond,:);
                elseif stim_ind ==4
                    data0 = dataToFit(dataToFit(:,1)==3 & dataToFit(:,2)==cond,:);
                end

                %the rmse between the data and the three templates
                swRMSE = sqrt(mean((data0(:,7)-data0(:,8)).^2));
                saRMSE = sqrt(mean((data0(:,7)-data0(:,9)).^2));
                slRMSE = sqrt(mean((data0(:,7)-data0(:,10)).^2));

                %store the results
                if eyedata ==1
                    Win_LElow = [Win_LElow; swRMSE];
                    Avg_LElow = [Avg_LElow; saRMSE];
                    Los_LElow = [Los_LElow; slRMSE];
                elseif eyedata ==2
                    Win_LEhigh = [Win_LEhigh; swRMSE];
                    Avg_LEhigh = [Avg_LEhigh; saRMSE];
                    Los_LEhigh = [Los_LEhigh; slRMSE];
                end
            end
            %add in subject and stim info 
            Subj = [Subj;['S',num2str(s)]];
            Surround = [Surround;ctxt{cond}];
            StimName = [StimName; stimname{stim_ind}];
        end
    end
end

%save to csv file
T = table(Subj,Surround,StimName,...
    Win_LElow,Avg_LElow,Los_LElow,...
    Win_LEhigh,Avg_LEhigh,Los_LEhigh);

writetable(T,'Expt1_eye_tempRMSE.csv');

%% Expt 1 determine the eye dominance using the mean surround result
expt1_subjeye = [];
expt1_subjeye_strength = [];

for s = 1:10
    %which stimulus to use to determine eye dominance? 
    for stim = 1:5
        if stim==1 %use 1cpd data RMSE
            MS_stim = T(strcmp(T.Subj,['S',num2str(s)])&strcmp(T.Surround,'MS')& strcmp(T.StimName,'G1'),:);
        elseif stim ==2 %use 5cpd data RMSE
            MS_stim = T(strcmp(T.Subj,['S',num2str(s)])&strcmp(T.Surround,'MS')& strcmp(T.StimName,'G5'),:);
        elseif stim ==3 %use noise data RMSE
            MS_stim = T(strcmp(T.Subj,['S',num2str(s)])&strcmp(T.Surround,'MS')& strcmp(T.StimName,'Noise'),:);
        elseif stim ==4 %use natural data RMSE
            MS_stim = T(strcmp(T.Subj,['S',num2str(s)])&strcmp(T.Surround,'MS')& strcmp(T.StimName,'Natural'),:);
        elseif stim==5 %across all stims
            MS_stim = T(strcmp(T.Subj,['S',num2str(s)])&strcmp(T.Surround,'MS'),:);
        end

        %use the RMSE againt the Winner-take-all template
        LElow = mean(MS_stim.Win_LElow);
        LEhigh = mean(MS_stim.Win_LEhigh);

        %determine which set of eye-based trials show better winner take all pattern 
        if LElow<LEhigh %LElow trials show better winner take all pattern (smaller rmse)
            domLeft = 0; %thus LE is not the dominant eye
        else %LEhigh has less RMSE with the winner take all template
            domLeft = 1; %thus LE is the dominant eye
        end

        %store if the left eye is dominant or not
        expt1_subjeye(s,stim) = domLeft;
    end
end

%save subject's dominant eye info
expt1_subjeye = [[1:1:10]',expt1_subjeye];
save('Expt1_subjeyedom.mat','expt1_subjeye');

%% Expt 2 calculate the rmse

clear all;
addpath('../');
addpath('../expt2 data');

%stim info
contrasts = [0 0.25 0.5 1];
ctxt = {'MS','HS'};
stimname = {'G5','G5_horz','G5_blur','No4','No4_histeq','No4_bandpass','No4_bar','No4_blur'};

%subject and stim info to be stored
Subj = {};
Surround = {};
StimName = {};

%store the RMSE
Win_LElow = [];
Avg_LElow = [];
Los_LElow = [];
Win_LEhigh = [];
Avg_LEhigh = [];
Los_LEhigh = [];

%get the non-outlier list of subjects
load('expt2subj.mat');
ss = slist';

for s = ss
    filename = ['BCF_',num2str(s),'.mat'];
    load(filename);
    
    % with method of adjustment, sometimes Matlab doesn't allow value to be
    % exactly zero. Replace very very small values with 0 
    dat.resp(dat.resp(:,1)<1e-15) = 0; 
    data = [dat.stim dat.resp];
    
    %find trials
    for cond = [1 2] %only mean surround and high surround
        for stim_ind = 1:8
            
            stimdata_LElow = [];
            stimdata_LEhigh = [];
            subdata = data(data(:,1)==stim_ind & data(:,2)==cond,:);
            
            %separate out trials where LE C > RE C and LE C < RE C
            for ii = 1:size(contrasts,2)
                for jj = 1:size(contrasts,2)
                    LE = contrasts(ii);
                    RE = contrasts(jj);
                    ind = find(subdata(:,3)==LE & subdata(:,4)==RE);
                    thisdata = subdata(ind,:);
                    if ~isempty(thisdata)
                        %add in the three predictions
                        thisdata(1,7) = max(thisdata(1,3:4)); %winner
                        thisdata(1,8) = mean(thisdata(1,3:4)); %averaging
                        thisdata(1,9) = min(thisdata(1,3:4)); %loser
                        if LE<RE %left eye is seeing the lower contrast
                            stimdata_LElow = [stimdata_LElow ; thisdata];
                        elseif LE>RE %left eye is seeing the higher contrast
                            stimdata_LEhigh  = [stimdata_LEhigh  ; thisdata];
                        end
                    end
                end
            end
            
            for eye = 1:2
                if eye==1
                    data0 = stimdata_LElow;
                elseif eye ==2
                    data0 = stimdata_LEhigh;
                end
                
                %RMSE against the three templates
                swRMSE = sqrt(mean((data0(:,6)-data0(:,7)).^2));
                saRMSE = sqrt(mean((data0(:,6)-data0(:,8)).^2));
                slRMSE = sqrt(mean((data0(:,6)-data0(:,9)).^2));
                if eye ==1 %LE low
                    Win_LElow = [Win_LElow; swRMSE];
                    Avg_LElow = [Avg_LElow; saRMSE];
                    Los_LElow = [Los_LElow; slRMSE];
                elseif eye ==2 %LE high
                    Win_LEhigh = [Win_LEhigh; swRMSE];
                    Avg_LEhigh = [Avg_LEhigh; saRMSE];
                    Los_LEhigh = [Los_LEhigh; slRMSE];
                end
            end
            Subj = [Subj;['S',num2str(s)]];
            Surround = [Surround;ctxt{cond}];
            StimName = [StimName; stimname{stim_ind}];
            %
        end
        
    end
    
end


T2 = table(Subj,Surround,StimName,...
    Win_LElow,Avg_LElow,Los_LElow,...
    Win_LEhigh,Avg_LEhigh,Los_LEhigh);

writetable(T2,'Expt2_eye_tempRMSE.csv');

%find out the eye dominance  
expt2_subjeye = [];
expt2_subjeye_strength = [];
row = 1;
for s = ss
    for stim = 1:9 %1-8=specific stim, 9 = all stim eye dominance 
        if stim==1
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'G5'),:);
        elseif stim ==2
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'G5_horz'),:);
        elseif stim ==3
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'G5_blur'),:);
        elseif stim ==4
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'No4'),:);
        elseif stim ==5
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'No4_histeq'),:);
        elseif stim ==6
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'No4_bandpass'),:);
        elseif stim ==7
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'No4_bar'),:);
        elseif stim ==8
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS')& strcmp(T2.StimName,'No4_blur'),:);
        elseif stim ==9
            MS_stim = T2(strcmp(T2.Subj,['S',num2str(s)])&strcmp(T2.Surround,'MS'),:);
        end

        LElow = mean(MS_stim.Win_LElow);
        LEhigh = mean(MS_stim.Win_LEhigh);
        
        %determine which set of eye-based trials show better winner take all pattern 
        if LElow<LEhigh %LElow trials show better winner take all pattern (smaller rmse)
            domLeft = 0; %thus LE is not the dominant eye
        else %LEhigh has less RMSE with the winner take all template
            domLeft = 1; %thus LE is the dominant eye
        end
        expt2_subjeye(row,stim) = domLeft;
    end
    row = row+1;
    
end
%save subject's dominant eye info
expt2_subjeye = [ss',expt2_subjeye];
save('Expt2_subjeyedom.mat','expt2_subjeye');



