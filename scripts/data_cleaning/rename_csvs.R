setwd("data/50km_BCR_spp_matrices")

old.names <- list.files(pattern = "csv", recursive = TRUE)

new.names <- paste0("50km_",old.names)
new.names <- gsub("/", "_", new.names)
new.names <- file.path(dirname(old.names), new.names)


file.rename(old.names, new.names)

getwd()
