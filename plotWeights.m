clear all;
%make the figures big
set(groot,'defaultfigureposition',[100 100 1700 700]);

individual = 1; %flag for plotting individual weight or not

%load the processed data(weights) for plotting
load('Expt1_weights.mat');
load('Expt2_weights.mat');

expt1 = expt1weights;
expt2 = expt2weights;

%% Experiment 1
condtxt = {'Mean Surround','Low Surround','High Surround'};

for cond = 1:3 %select the surround condition
    cond_data = [];

    %combine the weights for different noise and natural image exemplars
    for stim = 1:4 

        if stim ==1 || stim ==2 %1cpd and 5cpd -- don't combine
            data = expt1(expt1(:,2)==cond & expt1(:,3)==stim,:);
            cond_data = [cond_data,data(:,4)];

        elseif stim ==3 % noise
            data = expt1(expt1(:,2)==cond & (expt1(:,3)>2 & expt1(:,3)<7),:);
            data2 = [];
            for s = 1:10 %average the exemplers for each subject before across subjects
                subdata = data(data(:,1)==s,:);
                avg = mean(subdata(:,4)); %the average across examplers
                data2 = [data2; s cond stim avg];
            end
            cond_data = [cond_data,data2(:,4)];

        elseif stim ==4 % natural images
            data = expt1(expt1(:,2)==cond & expt1(:,3)>6 ,:);
            data2 = [];
            for s = 1:10 %average the exemplers for each subject before across subjects
                subdata = data(data(:,1)==s,:);
                avg = mean(subdata(:,4)); %the average across examplers
                data2 = [data2; s cond stim avg];
            end
            cond_data = [cond_data,data2(:,4)];

        end

    end

    %make the plot
    figure(1);
    subplot(2,3,cond);
    hold on;
    boxplot(cond_data,'Colors',[0.99 0.64 0.32; 0.88 0 0.5;0.52 0.67 0.36;0 0.4 0.99],'Symbol','');
    if individual ==1
        plot(ones(1,size(cond_data,1))*(1)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,1),'k.');
        plot(ones(1,size(cond_data,1))*(2)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,2),'k.');
        plot(ones(1,size(cond_data,1))*(3)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,3),'k.');
        plot(ones(1,size(cond_data,1))*(4)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,4),'k.');
    end
    xlim([0.5 4.5]);
    ylim([-0.1 1.1]);
    yticks([0 0.5 1])
    xticks([1 2 3 4]);
    set(gca,'xticklabel',{'G1','G5','Noise','Natural'});
    xtickangle(45);
    title(condtxt{cond});
    ylabel('Weight of High Contrast');
    axis square;
    
end

%% Experiment 2 main plots
figure(2);
condtxt = {'Mean Surround','High Surround'};
%what does each stim number correspond to
expt2_label = {'Grat','Grat Horz','Grat Blur',...
    'Noise','Noise histeq','Noise bandpass','Broadband (1D)','Noise blur'};

for cond = 1:2 %select the surround condition
    cond_data = [];
    for stim = [1 4 5 6 7] %select the main stimuli
        data = expt2(expt2(:,2)==cond & expt2(:,3)==stim,:);
        cond_data = [cond_data,data(:,4)];
    end

    %make the plot
    subplot(1,2,cond);
    hold on;
    if individual ==1
        plot(ones(1,size(cond_data,1))*(1)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,1),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(2)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,2),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(3)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,3),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(4)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,4),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(5)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,5),'k.','MarkerSize',10);
    end
    boxplot(cond_data,'Colors',[0.88 0 0.5;0.52 0.67 0.36; 0.51,0.72,0.71;0.51,0.72,0.71;0.51,0.72,0.71],'Symbol','');
    xlim([0 6]);
    ylim([-0.1 1.1]);
    xticks([1 2 3 4 5]);
    yticks([0 0.5 1]);
    set(gca,'xticklabel',{'Grat','Noise','Hist eq','Bandpass','1D'});
    xtickangle(45);
    title(condtxt{cond});
    box on;
    axis square;
    ylabel('Weight of High Contrast');

end


%% Expt 2 horizontal grating vs vertical grating
figure(3);

for cond = 1:2
    cond_data = [];
    for stim = [1,2]%1:8
        
        data = expt2(expt2(:,2)==cond & expt2(:,3)==stim,:);
        cond_data = [cond_data, data(:,4)];
    end
    %make the plot
    subplot(2,2,cond);
    hold on;
    boxplot(cond_data,'Colors',[0.88 0 0.5;1 0 0.8],'OutlierSize',0.1);
    if individual ==1
        plot(ones(1,size(cond_data,1))*(1)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,1),'k.');
        plot(ones(1,size(cond_data,1))*(2)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,2),'k.');
    end
    xlim([0 3]);
    ylim([-0.1 1.1]);
    xticks([1 2]);
    set(gca,'xticklabel',{'GratV','GratH'});
    xtickangle(45);
    title(condtxt{cond});
    box on;
    axis square;
    ylabel('Weight of High Contrast');
end


%% blur conditions
figure(4);

for cond = 1:2
    cond_data = [];
    for stim = [1 3 4 8] %baseline grating/noise and blur conditions
        data = expt2(expt2(:,2)==cond & expt2(:,3)==stim,:);
        cond_data = [cond_data, data(:,4)];
    end
    %make the plot
    subplot(1,2,cond);
    hold on;
    boxplot(cond_data,'Colors',[0.88 0 0.5;0.88 0 0.5;0.52 0.67 0.36;0.52 0.67 0.36],'Symbol','');
    if individual ==1
        plot(ones(1,size(cond_data,1))*(1)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,1),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(2)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,2),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(3)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,3),'k.','MarkerSize',10);
        plot(ones(1,size(cond_data,1))*(4)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,4),'k.','MarkerSize',10);
    end
    
    xlim([0 5]);
    ylim([-0.1 1.1]);
    xticks([1 2 3 4]);
    yticks([0 0.5 1]);
    set(gca,'xticklabel',{'Grat','Grat Blur','Noise','Noise blur'});
    xtickangle(45);
    title(condtxt{cond});
    box on;
    axis square;
    ylabel('Weight of High Contrast');
end



