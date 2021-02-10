## ---------------------------
##
## Script name: plotting_metrics.R
##
## Purpose of script: plot BCR metrics against each other for evaluation
##
## Author: Jesse A. Laney
##
## Date Created: 2020-11-12
##
## Copyright (c) Jesse A. Laney, 2021
## Email: jessealaney@gmail.com
##
## ---------------------------
##
## Notes: work in progress
##   
##
## ---------------------------

library(tidyverse)
library(GGally)


##### plot biodiversity metrics

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots")

for (i in seq_along(biometrics)) {
  try( {
    filename = biometrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
    axis.text = element_text(size = 6),
    axis.title = element_text(size = 6),
    legend.background = element_rect(fill = "white"),
    panel.grid.major = element_line(colour = NA),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "grey95"))
  
  png(paste0("biometrics_",names(biometrics)[i],".png"), units="in", width=14, height=14, res=300)
  print(g)
  dev.off()  
  }
  )}


#Create subsets of env metric list
elev_metrics<- list()
roughness_metrics <- list()
TPI_metrics <- list()
TRI_metrics <- list()
VRM_metrics <- list()

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots/env_plots/elev/")

#########fill lists with data frames for only desired env. metrics
########first elevation metrics per BCR

for (i in seq_along(envmetrics)) {
  df = envmetrics[[i]]
  
  df <- df[,c(1:10),]
  
  elev_metrics[[i]] <- df # save your dataframes into the list

}

###### and plot

for (i in seq_along(elev_metrics)) {
  try( {
    filename = elev_metrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
      axis.text = element_text(size = 6),
      axis.title = element_text(size = 6),
      legend.background = element_rect(fill = "white"),
      panel.grid.major = element_line(colour = NA),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "grey95"))
    
    png(paste0("elev_metrics_",names(envmetrics)[i],".png"), units="in", width=14, height=14, res=300)
    print(g)
    dev.off()  
  }
  )}

######again for roughness

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots/env_plots/roughness/")

for (i in seq_along(envmetrics)) {
  df = envmetrics[[i]]
  
  df <- df[,c(11:20),]
  
  roughness_metrics[[i]] <- df # save your dataframes into the list
  
}

for (i in seq_along(roughness_metrics)) {
  try( {
    filename = roughness_metrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
      axis.text = element_text(size = 6),
      axis.title = element_text(size = 6),
      legend.background = element_rect(fill = "white"),
      panel.grid.major = element_line(colour = NA),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "grey95"))
    
    png(paste0("roughness_metrics_",names(envmetrics)[i],".png"), units="in", width=14, height=14, res=300)
    print(g)
    dev.off()  
  }
  )}

###### now for TPI

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots/env_plots/TPI/")

for (i in seq_along(envmetrics)) {
  df = envmetrics[[i]]
  
  df <- df[,c(21:30),]
  
  TPI_metrics[[i]] <- df # save your dataframes into the list
  
}

for (i in seq_along(TPI_metrics)) {
  try( {
    filename = TPI_metrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
      axis.text = element_text(size = 6),
      axis.title = element_text(size = 6),
      legend.background = element_rect(fill = "white"),
      panel.grid.major = element_line(colour = NA),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "grey95"))
    
    png(paste0("TPI_metrics_",names(envmetrics)[i],".png"), units="in", width=14, height=14, res=300)
    print(g)
    dev.off()  
  }
  )}

##### TRI

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots/env_plots/TRI/")

for (i in seq_along(envmetrics)) {
  df = envmetrics[[i]]
  
  df <- df[,c(31:40),]
  
  TRI_metrics[[i]] <- df # save your dataframes into the list
  
}

for (i in seq_along(TRI_metrics)) {
  try( {
    filename = TRI_metrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
      axis.text = element_text(size = 6),
      axis.title = element_text(size = 6),
      legend.background = element_rect(fill = "white"),
      panel.grid.major = element_line(colour = NA),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "grey95"))
    
    png(paste0("TRI_metrics_",names(envmetrics)[i],".png"), units="in", width=14, height=14, res=300)
    print(g)
    dev.off()  
  }
  )}

##### VRM

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/plots/env_plots/VRM/")

for (i in seq_along(envmetrics)) {
  df = envmetrics[[i]]
  
  df <- df[,c(41:50),]
  
  VRM_metrics[[i]] <- df # save your dataframes into the list
  
}

for (i in seq_along(VRM_metrics)) {
  try( {
    filename = VRM_metrics[[i]]
    
    g <- ggpairs(data= filename,lower = list(continuous = wrap("smooth", alpha = 0.3, color = "blue")),upper = list(continuous = wrap(ggally_cor, size = 4, color = "black")))
    g <- g + theme(
      axis.text = element_text(size = 6),
      axis.title = element_text(size = 6),
      legend.background = element_rect(fill = "white"),
      panel.grid.major = element_line(colour = NA),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "grey95"))
    
    png(paste0("VRM_metrics_",names(envmetrics)[i],".png"), units="in", width=14, height=14, res=300)
    print(g)
    dev.off()  
  }
  )}
