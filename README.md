# DichopticSpatialStructure
This repository contains the data and code accompanying:

Minqi Wang, Jian Ding, Dennis M. Levi, Emily A. Cooper; 
The effect of spatial structure on binocular contrast perception. 
Journal of Vision 2022;22(12):7. 
doi: https://doi.org/10.1167/jov.22.12.7.

The top level directory contains scripts for loading, processing, and plotting the data from both Experiments. The script "runMe.m" is the master script that calls all the others and contains comments explaining what each script does. These scripts also save out data files that are used for statistical analysis, but the statistical analysis scripts are contained within the "stats" subfolder. The subfolder titled "eye_dominance_analysis" contains the exploratory analysis of eye dominance differences.

Data from both experiments are contained in these folders. Each file contains the data from one participant in the following data structreL

- expt1 data
	-dat.stim: stimulus information
		- col 1 = surround type (1 = mean surround, 2 = low surround, 3 = high surround)
		- col 2 = stimulus type (1 = grating, 2 = noise, 3 = natural)
		- col 3 = stimulus exemplar number (grating 1 or 5=1cpd and 5cpd, noise 1-4 where 1-3 are phase scrambled natural, natural 1-3)
		- col 4 = left eye center contrast
		- col 5 = right eye center contrast
		- col 6 = surround contrast for both eyes
	-dat.resp: final adjusted contrast value for the non-dichoptic stimulus
- expt2 data
	- dat.stim: stimulus information
		- col 1 = stimulus type (1=vertical 5cpd,2=horizontal 5cpd,3= grating blur,4=noise,5=hist eq,6=bandpass,7=broadband,8=noise blur)
		- col 2 = surround type (1 = mean surround, 2 = high surround)
		- col 3 = left eye center contrast
		- col 4 = right eye center contrast
		- col 5 = surround contrast
	- dat.resp: final adjusted contrast value for the non-dichoptic stimulus
