## ---------------------------
##
## Script name: env_metrics.R
##
## Purpose of script: reads in environmental metrics per grid cell per BCR that was already derived in QGIS. 
## 
## This script is called by NA_passerines_dimensionality.R
##
## Author: Jesse A. Laney
##
## Date Created: 2020-2-8
##
## Copyright (c) Jesse A. Laney, 2021
## Email: jessealaney@gmail.com
##
## ---------------------------


#install.packages("pacman") 
#pacman::p_load(ape, phytools, plyr, picante, treescape, janitor, vegan, pez, FD, classInt, tibble,phyloregion, data.table, tools, tidyr, dplyr)

envmetrics<- list() #Create a list in which you intend to save your df's.

#read all csvs into a different list
env_metrics_csvs<- list.files (path = "./data/50km_BCR_env_matrices/CSV/", pattern = "csv", recursive = TRUE, full.names = TRUE)

for (i in seq_along(env_metrics_csvs)) {
      filename = env_metrics_csvs[[i]]
      
      env.ds <- read.csv(filename, header = TRUE)
      
      env.ds <- env.ds[,c(2,25:174),]
      env.ds <-unique(env.ds)
      env.ds <- env.ds[,c(2:151),]
      
      envmetrics[[i]] <- env.ds # save your dataframes into the list
      
    }
    
#rename metric dataframes in list
names(envmetrics) <- stringr::str_replace(env_metrics_csvs, pattern = ".csv", replacement = "")
names(envmetrics)<-sub('.*\\//', '', env_metrics_csvs)

colnames(envmetrics[[i]])
#reorder metrics data frame




      
