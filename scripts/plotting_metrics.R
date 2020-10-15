# Basic Scatterplot Matrix
pairs(~traits$HWI,traits$Body.mass..log., traits$Body.mass...log, data=traits,
      main="Simple Scatterplot Matrix")

plot(traits)

library(plyr)
library(readr)
library(ggplot2)

setwd("/Users/jesselaney/Desktop/Passerines/breeding_BCR_metrics")

file_list <- list.files(path = "/Users/jesselaney/Desktop/Passerines/breeding_BCR_metrics", pattern = "*_breeding_metrics.csv")

plot.list = lapply(file_list, function(file) {
  df = read_csv(file)
  plot(df,
        main="Simple Scatterplot Matrix")
})

# Lay out all the plots together
library(gridExtra)
do.call(grid.arrange, plot.list) 

library(tidyverse)
library(GGally)

data <- read.csv("BCR_40_breeding_metrics.csv", header = TRUE, row.names = 1)

quartz()

# new, better plot (for my print size)
ggpairs(
  data, columns = c(1:8), 
  upper = list(
    continuous = wrap("cor", size = 4.75, alignPercent = 1)
  )
)

