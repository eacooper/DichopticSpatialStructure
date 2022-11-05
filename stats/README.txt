This folder contains R scripts for conducting the statistical analysis on the fitted weights from Experiments 1 and 2. WeightData is a csv file containing the processed data (weight of the higher contrast eye) from all the different conditions in the two experiments

permData_main.R & permData_other.R
- analysis code for running permutation anova and regular anova for effect size
- main= analysis of main stimuli, other=analysis of horizontal grating and blur conditions in Expt 2

expt1_pairwise.R & expt2_pairwise.R
- selection of predetermined pairwise comparisons of interest (with Wilcoxin signrank test) based on the significant interactions from the main ANOVA analysis
- outputs csv files (expt1_signrank_surround, expt1_signrank_stim, expt2_signrank_surround, expt2_signrank_stim) containing just the pairwise comparisons of interest

SignRank_correction.xlsx contains a manual copy of the CSV files where Bonferroni correction is applied