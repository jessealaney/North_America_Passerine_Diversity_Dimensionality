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
## Copyright (c) Jesse A. Laney, 2020
## Email: jessealaney@gmail.com
##
## ---------------------------
##
## Notes: work in progress
##   
##
## ---------------------------

setwd("/Users/jesselaney/North_America_Passerine_Diversity_Dimensionality/50km_biometrics")


library(tidyverse)
library(GGally)

data <- read.csv("_biometrics.csv", header = TRUE, row.names = 1)

quartz()

g <- ggpairs( 
  data= read.csv("_biometrics.csv", header = TRUE, row.names = 1),
  lower = list(
    continuous = wrap("smooth", alpha = 0.3, color = "blue") 
  ),
  upper = list(continuous = wrap(ggally_cor, size = 2, color = "black")))
g <- g + theme(
  axis.text = element_text(size = 6),
  axis.title = element_text(size = 6),
  legend.background = element_rect(fill = "white"),
  panel.grid.major = element_line(colour = NA),
  panel.grid.minor = element_blank(),
  panel.background = element_rect(fill = "grey95")
)
print(g, bottomHeightProportion = 0.5, leftWidthProportion = .5)
