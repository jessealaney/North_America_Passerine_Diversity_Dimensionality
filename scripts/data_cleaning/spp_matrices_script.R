install.packages('gmodels')
install.packages('reshape2')
install.packages('tidyr')
install.packages('stringr')
install.packages('tidyverse')

getwd()

library(stringr)
library(gmodels) 
library(reshape2)
library(dplyr)
library(tidyverse)

#read in csvs from gis atrribute table
breeding <- read.csv('50km_breeding_spp.csv') 
nonbreeding <- read.csv('50km_nonbreeding_spp.csv') 
resident <- read.csv('50km_resident_spp.csv') 
passage <- read.csv('50km_passage_spp.csv') 
resident_breeding <- read.csv('50km_resident_breeding_spp.csv') 

#convert to spp tables retaining cell and BCR
breeding_spp <-dcast(breeding, cell+BCR~species, length)
nonbreeding_spp <-dcast(nonbreeding, cell+BCR~species, length)
passage_spp <-dcast(passage, cell+BCR~species, length)
resident_spp <-dcast(resident, cell+BCR~species, length)
resident_breeding_spp <-dcast(resident_breeding, cell+BCR~species, length)

#get rid of all non-zero values
tmp <- select(breeding_spp, -cell, -BCR)
tmp[tmp != 0] <- 1
tmp_index <- select(breeding_spp, cell, BCR)
breeding_spp2 <- cbind(tmp_index, tmp)

tmp2 <- select(resident_spp, -cell, -BCR)
tmp2[tmp2 != 0] <- 1
tmp_index2 <- select(resident_spp, cell, BCR)
resident_spp2 <- cbind(tmp_index2, tmp2)

tmp3 <- select(resident_breeding_spp, -cell, -BCR)
tmp3[tmp3 != 0] <- 1
tmp_index3 <- select(resident_breeding_spp, cell, BCR)
resident_breeding_spp2 <- cbind(tmp_index3, tmp3)

tmp4 <- select(nonbreeding_spp, -cell, -BCR)
tmp4[tmp4 != 0] <- 1
tmp_index4 <- select(nonbreeding_spp, cell, BCR)
nonbreeding_spp2 <- cbind(tmp_index4, tmp4)

tmp5 <- select(passage_spp, -cell, -BCR)
tmp5[tmp5 != 0] <- 1
tmp_index5 <- select(passage_spp, cell, BCR)
passage_spp2 <- cbind(tmp_index5, tmp5)

#write csvs
write.csv(breeding_spp2,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/breeding_spp.csv", row.names = FALSE)
write.csv(nonbreeding_spp2,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/nonbreeding_spp.csv", row.names = FALSE)
write.csv(resident_spp2,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/resident_spp.csv", row.names = FALSE)
write.csv(passage_spp2,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/passage_spp.csv", row.names = FALSE)
write.csv(resident_breeding_spp2,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/resident_breeding_spp.csv", row.names = FALSE)

#create individual csv's based cell's on BCR designations
BCRlist <- split(breeding_spp, breeding_spp$BCR)
lapply(names(BCRlist), function(name) write.csv(BCRlist[[name]], file = paste('breeding_BCR/',gsub('','',name),'.csv',sep=''), row.names = F))

BCRlist2 <- split(resident_spp, resident_spp$BCR)
lapply(names(BCRlist2), function(name) write.csv(BCRlist2[[name]], file = paste('resident_BCR/',gsub('','',name),'.csv',sep=''), row.names = F))

BCRlist3 <- split(resident_breeding_spp, resident_breeding_spp$BCR)
lapply(names(BCRlist3), function(name) write.csv(BCRlist3[[name]], file = paste('resident_breeding_BCR/',gsub('','',name),'.csv',sep=''), row.names = F))

BCRlist4 <- split(nonbreeding_spp, nonbreeding_spp$BCR)
lapply(names(BCRlist4), function(name) write.csv(BCRlist4[[name]], file = paste('nonbreeding_BCR/',gsub('','',name),'.csv',sep=''), row.names = F))

BCRlist5 <- split(passage_spp, passage_spp$BCR)
lapply(names(BCRlist5), function(name) write.csv(BCRlist5[[name]], file = paste('passage_BCR/',gsub('','',name),'.csv',sep=''), row.names = F))


#total_spp
total <- read.csv('50km_total.csv') 
df = subset(total, select = c(id,SCINAME,SEASONAL,layer))
colnames(df) <- c("cell", "species", "seasonal_code", "BCR")
head(df)
# performing excel “text to column” to extract country this creates a LIST of split elements:
split <- str_split(df$BCR, "_")
split
class(split[[1]])
is.vector(split[[1]])
#df$crap1 <- sapply(split, "[[", 1)
#df$crap2 <- sapply(split, "[[", 2)
df$BCR <- sapply(split, "[[", 3)
total_spp <-dcast(df, cell+BCR~species, length)
write.csv(total_spp,"/Users/jesselaney/Desktop/Passerines/North America/50km_grid_cell_data/work/total_spp.csv", row.names = FALSE)
