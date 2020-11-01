## ---------------------------
##
## Script name: NA_passerines_dimensionality.R
##
## Purpose of script: master script
##
## Author: Jesse A. Laney
##
## Date Created: 2020-10-27
##
## Copyright (c) Jesse A. Laney, 2020
## Email: jessealaney@gmail.com
##
## ---------------------------
##
## Notes: work in progress
##   
##
## ---------------------------


## load up the packages we will need:

pacman::p_load(ape, phytools, plyr, picante, treescape, janitor, vegan, pez, FD, classInt,
               tibble,phyloregion, data.table, tools, tidyr, dplyr)

## ---------------------------

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/")

## load up our functions into memory

source("scripts/birdtree.R")
source("scripts/biodiversity_metrics.R") 
#source("scripts//environmental_metrics.R") 
#source("scripts//multivariate_analyses.R")
#source("scripts//regression_analyses.R") 

## ---------------------------



