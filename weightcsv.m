%process data to make a CSV file for R
clear all;

%% Expt 1
load('Expt1_weights.mat');
ctxt = {'MS','LS','HS'};
stimname2 = {'1cpd','5cpd','noise','natural'};
Expt = {};
Subj = {};
Surround = {};
StimName = {};
FitParam = [];
CondCombo = {};


for cond = 1:3

    condata = expt1weights(expt1weights(:,2)==cond,:);

    % select subset of data
    for stim = 1:4
        if stim ==1
            subdata = condata(condata(:,3)==1,:);
        elseif stim ==2
            subdata = condata(condata(:,3)==2,:);
        elseif stim ==3 %find the noise exemplars
            subdata = condata(condata(:,3)==3 | condata(:,3)==4 | condata(:,3)==5 | condata(:,3)==6,:);
        elseif stim ==4 %find the natural exemplars
            subdata = condata(condata(:,3)==7 | condata(:,3)==8 | condata(:,3)==9,:);
        end
        for s = 1:10 
            %average weight across the exemplars
            ex_avg = mean(subdata(subdata(:,1)==s,4));
            
            %code stim and weight for csv
            Expt = [Expt; '1'];
            Subj = [Subj;['S',num2str(s)]];
            Surround = [Surround;ctxt{cond}];
            StimName = [StimName; stimname2{stim}];
            FitParam = [FitParam; ex_avg];
            CondCombo = [CondCombo;[ctxt{cond},'_',stimname2{stim}]];

        end
        
    end
end

%% Expt 2
load('Expt2_weights.mat');
ctxt = {'MS','HS'};
stimname = {'G5','G5_horz','G5_blur','No4','No4_histeq','No4_bandpass','No4_bar','No4_blur'};

load('expt2subj.mat');

for cond = 1:2
    condata = expt2weights(expt2weights(:,2)==cond,:);
    
    for stim = 1:8
        subdata = condata(condata(:,3)==stim,:);
        for s = 1:size(subdata,1)
            %get the fitted weight
            ex_avg = subdata(subdata(:,1)==slist(s),4);
            
            %code stim and weight for csv
            Expt = [Expt; '2'];
            Subj = [Subj;['S',num2str(subdata(s,1))]];
            Surround = [Surround;ctxt{cond}];
            StimName = [StimName; stimname{stim}];
            FitParam = [FitParam; ex_avg];
            CondCombo = [CondCombo;[ctxt{cond},'_',stimname{stim}]];
        end
        
    end
end

%% save to csv file
T = table(Expt,Subj,Surround,StimName,FitParam,CondCombo);
writetable(T,'./stats/WeightData.csv');

cc = T.Expt;

        