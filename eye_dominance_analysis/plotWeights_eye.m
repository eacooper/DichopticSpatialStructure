clear all;
close all;
set(groot,'defaultfigureposition',[100 100 1700 700]);

c1 = {'r','r','g','b'};
c2 = {'r','g','g','g','g'};
c3 = {'r','k'};
c4 = {'r','k','g','k'};

plotbox = 1;
individual = 1;

load('Expt1_weights.mat');
load('Expt2_weights.mat');

%cols = 1)subjid, 2) surround, 3) stim type, 4)weight
%col 5) eyedom categorization based on what stim (1-4 expt 1, 1-8 expt2, 5 and 9 = all stim), 6) D or ND eye (1,2)
%use the 5cpd grating as the eye dominance classifer

%pick which stim categorization to use, example {[2],[1]} correspond to
%stimulus #2 in expt1 (5cpd) and stimulus #1 in expt2 (5cpd)

a = {[2],[1]};%{[1 2 3 5],[1 4 9]};
b = {[1 2 3 4],[1 4 5 6 7]};
expt1 = expt1weights;
expt2 = expt2weights;

%expt1
condtxt = {'Mean Surround','Low Surround','High Surround'};
%let's combine the exxamplers for noise and natural images
for expt = 1:2
    if expt==1
        exptdata0 = expt1;
    elseif expt ==2
        exptdata0 = expt2;
    end
    
    for eye_stim = a{expt}
        for eye = 1:2
            exptdata = exptdata0(exptdata0(:,5)==eye_stim & exptdata0(:,6)==eye,:);
            for cond = 1:3
                cond_data = []; %matrix for box plot

                if expt ==1
                    cond_data = [];
                    for stim = b{expt}
                        if stim ==1 || stim ==2
                            data = exptdata(exptdata(:,2)==cond & exptdata(:,3)==stim,:);
                            cond_data = [cond_data,data(:,4)];
                        elseif stim ==3 %noise
                            data = exptdata(exptdata(:,2)==cond & (exptdata(:,3)>2 & exptdata(:,3)<7),:);
                            data2 = [];
                            for s = 1:10 %average the exemplers for each subject before across subjects
                                subdata = data(data(:,1)==s,:);
                                avg = mean(subdata(:,4)); %the average across examplers
                                data2 = [data2; s cond stim avg];
                            end
                            cond_data = [cond_data,data2(:,4)];
                        elseif stim ==4
                            data = exptdata(exptdata(:,2)==cond & exptdata(:,3)>6 ,:);
                            data2 = [];
                            for s = 1:10 %average the exemplers for each subject before across subjects
                                subdata = data(data(:,1)==s,:);
                                avg = mean(subdata(:,4)); %the average across examplers
                                data2 = [data2; s cond stim avg];
                            end
                            cond_data = [cond_data,data2(:,4)];
                        end
                    end
                elseif expt ==2
                    cond_data = [];
                    for stim = b{expt} 
                        data = exptdata(exptdata(:,2)==cond & exptdata(:,3)==stim,:);
                        cond_data = [cond_data, data(:,4)];
                    end
                    
                end
                
                
                if plotbox ==1
                    %mainplot = figure(cond);
                    if expt ==1
                        disp(cond_data)
                        figure(eye_stim);
                        subplot(2,3,(eye-1)*3+cond);
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
                        %set(gca,'xticklabel',{'1cpd','5cpd','Noise','Natural'});
                        xtickangle(45);
                        title(condtxt{cond});
                        %box on;
                        ylabel('Weight of High Contrast');
                        axis square;
                    elseif expt==2 && cond~=2
                        figure(20+eye_stim);
                        subplot(2,3,(eye-1)*3+cond);
                        hold on;
                        boxplot(cond_data,'Colors',[0.88 0 0.5;0.52 0.67 0.36;0.51,0.72,0.71;0.51,0.72,0.71;0.51,0.72,0.71],'Symbol','');
                        if individual ==1
                            plot(ones(1,size(cond_data,1))*(1)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,1),'k.');
                            plot(ones(1,size(cond_data,1))*(2)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,2),'k.');
                            plot(ones(1,size(cond_data,1))*(3)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,3),'k.');
                            plot(ones(1,size(cond_data,1))*(4)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,4),'k.');
                            plot(ones(1,size(cond_data,1))*(5)-0.25+rand(1,size(cond_data,1))*0.4,cond_data(:,5),'k.');
                        end
                        
                        xlim([0 6]);
                        ylim([-0.1 1.1]);
                        xticks([1 2 3 4 5]);
                        yticks([0 0.5 1]);
                        %set(gca,'xticklabel',{'Grat','Noise','Hist eq','Bandpass','Broadband (1D)'});
                        xtickangle(45);
                        title(condtxt{cond});
                        box on;
                        axis square;
                        ylabel('Weight of High Contrast');
                    end
                end
                
            end
        end
    end
    if expt ==1
        saveas(gcf,'exp1','epsc');
    else
        saveas(gcf,'exp2','epsc');
    end
end




