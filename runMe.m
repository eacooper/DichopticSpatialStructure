% The make the plots from the paper and prep for the statistical analyses,
% the scripts should be run in this order:

% - check the catch trial responses where the reference stimulus was non-dichoptic for outliers and visualize errors
% - store the id of the non-outliers in Experiment 2
outlierCriteria

% - take the contrast match data from both experiments and fit a weight for the high contrast eye that best accounts for the data in each condition for each subject
% - store and save the fitted weights as "Expt1_weights.mat" and "Expt2_weights.mat"
% Note that genBino is called by processData to take the weight of the high contrast eye and the dichoptic pair (high and low contrasts), 
% and then generate the predicted binocular perceived contrast based on the weighted combination
processData

% - visualize the best fitting weights (Figure 9,10,11)
plotWeights

% - format the weights stored in mat format into csv for statistical analysis in R (stats folder)
weightcsv

% Note: statistical analyses are contained in the stats folder