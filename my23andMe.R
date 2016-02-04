#loads required packages, downloads packages if necessary. 
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

library(data.table); library(dplyr)  

files_test<-list.files(pattern="_my23andMe.txt", full.names=TRUE)
files_23andMe<-bind_cols(lapply(files_test, fread, colClasses="character"))

files_23andMe<-files_23andMe[,c(1:4, 8)] # need to fix this for > 2 files 

names<-basename(files_test)
names_split<-strsplit(names, "_")
names_split<-sapply(names_split, function(x) x[1])
names(files_23andMe)<-c("snp", "chromosome", "position", names_split)

genes2personality<-fread("genes2personalityV2.txt", colClasses="character")

my23andMe<-merge(genes2personality, files_23andMe, by="snp")

my23andMe<- my23andMe %>%
  arrange(Personality.Trait) %>%
  select(-c(chromosome, position), everything())

write.table(my23andMe, "my23andMe.txt", row.names=F)

my23andMe_simple<- my23andMe_simple<-select(my23andMe, -c(Ancestral.Allele, MINOR.ALLELE.FREQUENCY.dbSNP, chromosome, position))

write.table(my23andMe_simple, "my23andMe_simple.txt", row.names=F)