## ---------------------------
##
## Script name: biodiversity_metrics.R
##
## Purpose of script: calculates biodiversity metrics per BCR cells per seasonality scenario. 
## 
## This script is called by NA_passerines_dimensionality.R
##
## Author: Jesse A. Laney
##
## Date Created: 2020-10-27
##
## Copyright (c) Jesse A. Laney, 2020
## Email: jessealaney@gmail.com
##
## ---------------------------


#install.packages("pacman") 
#pacman::p_load(ape, phytools, plyr, picante, treescape, janitor, vegan, pez, FD, classInt, tibble,phyloregion, data.table, tools, tidyr, dplyr)

#######set up loop#######

file_list <- list.files(path = "./data/50km_BCR_spp_matrices", pattern = "csv", recursive = TRUE, full.names = TRUE)

for (i in seq_along(file_list)) {
  try(
    {
      filename = file_list[[i]]
      
########Community Data############

# read BCR community data and use grid IDs as rownames (first column of data)
# use species names as colnames (default read.csv is header=TRUE) replace
#load community presence absence data set and remove BCR number data
comm.ds <- read.csv(filename, header = TRUE, row.names = 1)

class(comm.ds)
colnames(comm.ds)
names(comm.ds) <- gsub("\\.", "_", names(comm.ds))
colnames(comm.ds)
rownames(comm.ds)
comm.ds <- comm.ds[-1]
comm.ds <- comm.ds[,-(which(colSums(comm.ds)==0))] #removes columns that contain only zero values

#we need to clean up our community data, so that the species names match those in our phylogeny
#i am am supplying a file that does that
Phy_names <- read.csv("./data/reconciled_phy.csv", header = TRUE)
Phy_names$birdtree.names <- gsub(" ", "_", (Phy_names$birdtree.names))
Phy_names$dataset.names <- gsub(" ", "_", (Phy_names$dataset.names))

#replace column names with those in Phylogeny
names(comm.ds) <- Phy_names$birdtree.names[match(names(comm.ds), Phy_names$dataset.names)]

#now that we've replaced the species names with those in the phylogeny, we may have ended up with some clumping
#first we test for duplicated colnmaes
dup<-any(duplicated(names(comm.ds)))
#if TRUE, we need to sum values across cells in duplicate columns and get rid of the duplicate. 
if (dup == TRUE) {
  comm.ds <- cbind(sapply(unique(colnames(comm.ds)[duplicated(colnames(comm.ds))]), function(x) rowSums(comm.ds[,grepl(paste(x, "$", sep=""), colnames(comm.ds))])), comm.ds[,!duplicated(colnames(comm.ds)) & !duplicated(colnames(comm.ds), fromLast = TRUE)])
  #then we change those summed values to presence/absence
  comm.ds[comm.ds > 0] <- 1 
}

############Trait data############

#We can load traits in the same way as the community data, but now we will have species in the rows and traits in the columns.

# replace filename with file.choose() to open interactive window
traits <- read.csv("./data/traits.csv", header = TRUE, row.names = 1)

# add underscore between spp names
rownames(traits)
rownames(traits) <- gsub(" ", "_", rownames(traits))
rownames(traits)

# bin species into 10 groups using Jenks natural break classification for the log distribution of body sizes across all NA species
# Species body sizes are already logged in this case in the data set
# First, we read in total species in all BCRs.
total_spp <- read.csv("./data/total_spp_list.csv", header = TRUE)
total_spp$Species <- gsub(" ", "_",(total_spp$Species))
traits <- tibble::rownames_to_column(traits, "Species")

#Next, prune the dataset to only contain spp in BCRs using anti_join from the dplyr package.
tmp <-anti_join(traits, total_spp, by='Species')
traits <- anti_join(traits, tmp, by='Species')
rownames(traits) <- traits[,1]
traits[,1] <- NULL #Removing the first column

#break log body mass into 10 classes
pal1 <- c("wheat1", "red3")
#opar <- par(mfrow=c(2,3))
cl1 <- classIntervals(traits$Body.mass..log., n=10, style="jenks", pal=pal1, main="Jenks")
#plot(classIntervals(traits$Body.mass..log., n=10, style="jenks"), pal=pal1, main="Jenks")

#store those in a separate column in our trait dataset
traits$body.mass.jenks <- findCols(cl1)

#write.csv(Phy_names,"phy_names.csv", row.names = FALSE)
traits$birdtree_names <-Phy_names$birdtree.names

#clean up traits data
traits <- add_column(traits, Phy_names$birdtree.names, .before = "HWI")
colnames(traits)[1] <- "birdtree.names"
traits <- subset(traits, select = -c(birdtree_names))
traits <- add_column(traits, traits$body.mass.jenks, .before = "Range.Size")
traits <- subset(traits, select = -c(19))

# Now we remove duplicates to fix a couple of clumped species using the phylogeny names
# I ended up keeping the trait data for the conspecific with the larger range (n=3 out of 8...could change this later)
traits<-unique(setDT(traits)[order(birdtree.names, -Range.Size)], by = "birdtree.names")
traits <- traits[!is.na(traits$birdtree.names), ]
traits <- column_to_rownames(traits, 'birdtree.names')

########Phylogeny Data############

#plotTree(t3,fsize=0.4)
phy <- t3

# check for mismatches/missing species
combined <- match.phylo.comm(phy, comm.ds)
# the resulting object is a list with $phy and $comm elements.  replace our
# original data with the sorted/matched data (pruned tree)
phy <- combined$phy
comm <- combined$comm

#match trait data
combined <- match.phylo.data(phy, traits)
# the resulting object is a list with $phy and $data elements.  replace our
# original data with the sorted/matched data
phy <- combined$phy
traits <- combined$data

#plot the phylogeny 
#plot(phy, cex = 0.5)

####Calculate Metrics########

# empty the data frame
Metrics<- data.frame(Date=as.Date(character()),
                     File=character(), 
                     User=character(), 
                     stringsAsFactors=FALSE) 

# First lets calculate Phylogenetic metrics
comm.matrix<-data.matrix(comm, rownames.force = NA)
data<-comparative.comm(phy, comm.matrix, traits, env = NULL, warn = TRUE,
                 force.root = -1)

# Calculate Faith's PD and richness
Metrics <- pd(comm, phy)

#Calculate (Phylogenetic) Endemism
Metrics$PE<-pez.endemism(data, sqrt.phy = FALSE)
tmp<-Metrics$PE
Metrics$PE<-tmp$PE

#Calculate PSV
Metrics$PSV<-.psv(data)

#Calculate MPD
Metrics$MPD<-.mpd(data)

#Calculate MNTD
Metrics$MNTD<-.mntd(data)

#Calculate PSC
tmp<-psc(comm,phy)
Metrics$PSC<-tmp$PSCs

#Calculate functional metrics

#create a matrix based on diet niche (diet category + foraging category) and habitat type
diet_habitat_niche <- subset(traits, select = c(13:15))
traits_dist<-gowdis(diet_habitat_niche) # Gower distance because they are categorical traits

#calculate functional metrics for grid cells for the niche
diet_habitat_FD<-dbFD(traits_dist, comm.matrix, corr = "cailliez", m="min")

#diet_habitat_FD<-dbFD(traits_dist, comm.matrix, corr = "cailliez", calc.FRic = FALSE)
Metrics$Functional_Group_Richness<-diet_habitat_FD[["sing.sp"]]
Metrics$Functional_Richness<-diet_habitat_FD[["FRic"]]

#Metrics$Functional_Richness<- NA #blank column 
Metrics$Functional_Evenness<-diet_habitat_FD[["FEve"]]
Metrics$Functional_Divergence<-diet_habitat_FD[["FDiv"]]
Metrics$Functional_Dispersion<-diet_habitat_FD[["FDis"]]

#create matrix of body size classes  and calculate # and evenness of body size classes per grid cell
body_size_classes <-subset(traits, select = c(3))
body_size_FD<-dbFD(body_size_classes, comm.matrix) #corr = "cailliez")
Metrics$Body_Size_Richness<-body_size_FD[["FRic"]]
Metrics$Body_Size_Evenness<-body_size_FD[["FEve"]]

#calculate range weighted taxonomic richness of BCR (weighted endemism)
Metrics$WE<- weighted_endemism(comm.matrix)

colnames(Metrics)
#reorder metrics data frame
Metrics <- Metrics[,c(2,15,1,4:7,3,13,14,8,9,10:12),]

#write csv
#temp_name<-sapply(strsplit(filename, "/"), "[[", 5)
#subject_id <- gsub(temp_name, pattern=".csv$", replacement="")
#path <- "50km_biometrics/"
#write.csv(Metrics, file.path(path, subject_id, "_biometrics.csv", fsep=""), row.names=TRUE)

    },silent=T
  )

}
warnings()

