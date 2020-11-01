## ---------------------------
##
## Script name: birdtree.R
##
## Purpose of script: this script creates a consensus phylogeny from a multitree file
##
## Author: Jesse A. Laney
##
## Date Created: 2020-10-27
##
## Copyright (c) Jesse A. Laney, 2020
## Email: jessealaney@gmail.com
##
## ---------------------------

###Build Consensus Tree

#This script reads in a multitree file that contains 1000 phylogenetic passerine trees derived from Birdtree.org
#and then builds a consensus tree for use in further analyses by other scripts

# read in multitree file (here we’re using the read.nexus function from the APE package):
treefile <-read.nexus('./data/output.nex')

#Create a consensus tree from 1000 tree using the phytools package

## method 1
## Method 1: Compute the mean edge length for each edge in the consensus tree setting the length for each tree in which the edge is absent to zero. 
## (Default setting. Function arguments method="mean.edge" and if.absent="zero".)
#t1<-consensus.edges(treefile)
#plotTree(t1, fsize=0.4)

## method 2
## Method 2: Compute the mean edge length, but ignore trees in which the edge is absent. 
## (Function arguments method="mean.edge" and if.absent="ignore".)
#t2<-consensus.edges(treefile,if.absent="ignore")
#plotTree(t2,fsize=0.4)

## method 3
## Method 3: Compute the non-negative least squares edge lengths on the consensus tree using the mean patristic distance matrix. 
## (Function argument method="least.squares".)
## If the input trees are rooted & ultrametric, this can be used to produce a consensus tree that is also ultrametric.
t3<-consensus.edges(treefile,method="least.squares")
plotTree(t3,fsize=0.4)

## method 1, but with a 95% consensus tree
#t1.p95<-consensus.edges(trees,consensus.tree=consensus(trees,p=0.95))
#plotTree(t1.p95,fsize=0.4)

#It's hard to compare the results from each method, but we could
#correlate patristic distance matrices that each consensus tree implies:

#tips<-t1$tip.label
#plot(cophenetic(t1)[tips,tips],cophenetic(t2)[tips,tips],
#     xlab="Method 1",ylab="Method 2")
#h<-2*max(nodeHeights(t1))
#lines(c(0,h),c(0,h),lty="dashed",col="red",lwd=3)

#plot(cophenetic(t1)[tips,tips],cophenetic(t3)[tips,tips],
#     xlab="Method 1",ylab="Method 3")
#lines(c(0,h),c(0,h),lty="dashed",col="red",lwd=3)

### End Script ####
