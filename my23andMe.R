#This script merges your 23andMe raw data .txt file with a dataset known as genes2personalityV2. genes2personalityV2 #was created by eliminating blank rsIDs and random traits (hair curl, asparagus anosmia) from the genes2personality #file. In addition, possible alleles, ancestral allele and minor allele frequency (dbSNP-based on 1000 genomes) were #added manually from the dbSNP databank here: http://www.ncbi.nlm.nih.gov/projects/SNP/index.html. Future improvements #will be made to automatically add this data by connecting to the databank via the package rsnps for R. Column names #and order were also changed manually for clarity.  


#loads required packages, downloads packages if necessary. 
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("plyr")) {
  install.packages("plyr")
}

library(data.table); library(plyr); library(dplyr)  

#creates a directory for your 23andMe files
if (!file.exists("./my23andMe")){dir.create("./my23andMe")}

#downloads the genes2personalityV2 dataset from github
url = "https://raw.githubusercontent.com/dencook/genes2personality/master/genes2personalityV2.txt"
if (!file.exists("./my23andMe/genes2personalityV2.txt")){download.file(url, "./my23andMe/genes2personalityV2.txt")}

#lists and opens all files ending in _my23andMe.txt
files_test<-list.files(path="./my23andMe", pattern="_my23andMe.txt", full.names=TRUE)

#Extract a person's name from the filename
names<-basename(files_test)
names_split<-strsplit(names, "_")
names_split<-sapply(names_split, function(x) x[1])


if (length(files_test)==0) {
    print("Please add your raw 23andMe dataset to this folder and call it YourName_my23andMe.txt")
}else if (length(files_test)==1) {
    files_23andMe<-fread(files_test, colClasses="character")
    names(files_23andMe)<-c("snp", "chromosome", "position", names_split)
}else {
    files_23andMe<-lapply(files_test, fread, colClasses="character")
    for (i in seq_along(files_23andMe)) {
        names(files_23andMe[[i]])<-c("snp", "chromosome", "position", names_split[i])
    }
    files_23andMe<-join_all(files_23andMe, by=c("snp", "chromosome", "position"), type="full", match="first")
}


genes2personality<-fread("./my23andMe/genes2personalityV2.txt", colClasses="character")

my23andMe<-merge(genes2personality, files_23andMe, by="snp")

my23andMe<- my23andMe %>%
  arrange(Personality.Trait) %>%
  select(-c(chromosome, position), everything())

write.table(my23andMe, "./my23andMe/my23andMe.txt", row.names=F)

my23andMe_simple<- my23andMe_simple<-select(my23andMe, -c(Ancestral.Allele, MINOR.ALLELE.FREQUENCY.dbSNP, chromosome, position))

write.table(my23andMe_simple, "./my23andMe/my23andMe_simple.txt", row.names=F)