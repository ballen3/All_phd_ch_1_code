library(FUNGuildR)

## load in the file with the comma seperated taxonomy info
taxa <- read.csv("Research/ch_3/funguild_taxonomy_in.csv")

## assign guild
guilds <- funguild_assign(taxa)

## save as an R data frame
save(guilds,file="fungal_guilds.Rda")

## save it as a .csv
# write.csv(guilds, "Research/ch_3/fungal_guilds_output.csv", row.names=FALSE) 
