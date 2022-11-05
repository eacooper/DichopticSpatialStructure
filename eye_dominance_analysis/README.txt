This folder contains the exploratory follow up analysis of eye dominance differences. These scripts can be run in order to reproduce the analysis


processData_EyeDom.m
- separate out the trials where the left eye saw the higher contrast vs. the right eye saw the higher contrast
- for each eye's data, compute the root-mean-squared error against the three templates (winner-take-all, averaging, loser-take-all), used to assign the dominant eye

processData_EyeDom_weight.m
- fit weight to the dominant eye and nondominant eye data separately

plotWeights_eye.m (Figure 13)
- plot the dominant eye and nondominant eye data separately

calc_num_LEdom.m
- calculate the percentage of subjects in both experiments who are left eye dominant
