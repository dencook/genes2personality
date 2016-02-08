#This script merges your 23andMe raw data .txt file with a dataset known as genes2personalityV2. genes2personalityV2 #was created by eliminating blank rsIDs and random traits (hair curl, asparagus anosmia) from the genes2personality #file. In addition, possible alleles, ancestral allele and minor allele frequency (dbSNP-based on 1000 genomes) were #added manually from the dbSNP databank here: http://www.ncbi.nlm.nih.gov/projects/SNP/index.html. Future improvements #will be made to automatically add this data by connecting to the databank via the package rsnps for R. Column names #and order were also changed manually for clarity.  

#Hack to get around difference in ancestryDNA files: 
#myancestry_data<-fread("./myData/YourName_myData.txt", colClasses="character")
#YourName_mydata<-transmute(myancestry_data, rsid, chromosome, position, genotype=paste0(allele1, allele2))
#write.table(YourName_mydata, "./myData/YourName_mydata.txt", row.names=F)


#loads required packages, downloads packages if necessary. 
if (!require("data.table")) {
  install.packages("data.table", repos="https://cran.rstudio.com")
}

if (!require("plyr")) {
  install.packages("plyr", repos="https://cran.rstudio.com")
}

if (!require("dplyr")) {
  install.packages("dplyr", repos="https://cran.rstudio.com")
}

library(data.table); library(plyr); library(dplyr)  

#creates a directory for your 23andMe files
if (!file.exists("./myData")){dir.create("./myData")}

#downloads the genes2personalityV2 dataset from github
url = "https://raw.githubusercontent.com/dencook/genes2personality/master/genes2personalityV2.txt"
if (!file.exists("./myData/genes2personalityV2.txt")){download.file(url, "./myData/genes2personalityV2.txt")}

#lists and opens all files ending in _myData
files_test<-list.files(path="./myData", pattern="_myData", full.names=TRUE)

#Extract a person's name from the filename
names<-basename(files_test)
names_split<-strsplit(names, "_")
names_split<-sapply(names_split, function(x) x[1])

#checks for number of 23andMe files, joins them together if number > 1. Note that working with more than one dataset #slows down the program significantly. 
if (length(files_test)==0) {
    stop("Please add your raw 23andMe or FTDNA dataset to the myData folder and call it YourName_myData")
}else if (length(files_test)==1) {
    files_23andMe<-fread(files_test, colClasses="character")
    names(files_23andMe)<-c("snp", "chromosome", "position", names_split)
}else {
    files_23andMe<-lapply(files_test, fread, colClasses="character")
    for (i in seq_along(files_23andMe)) {
        names(files_23andMe[[i]])<-c("snp", "chromosome", "position", names_split[i])
    }
    files_23andMe<-join_all(files_23andMe, by="snp", type="full")
}

#read in the genes2personality dataset
genes2personality<-fread("./myData/genes2personalityV2.txt", colClasses="character")

#merges the genes2personality and 23andMe files by snpID
myData<-merge(genes2personality, files_23andMe, by="snp")

#rearranges by personality trait, moves chromosome and position to the end of the column list. Moves publication info #to end of list
myData<- myData %>%
  arrange(Personality.Trait) %>%
  select(-c(chromosome, position), everything())

#writes file containing all of the columns to the 23andMe folder
write.table(myData, "./myData/myData.txt", row.names=F)

#creates a subset of the major file
myData_simple<- myData_simple<-select(myData, -c(Ancestral.Allele, MINOR.ALLELE.FREQUENCY.dbSNP, chromosome, position, FIRST.AUTHOR, DATE, JOURNAL))

#writes this simple file to the 23andMe folder
write.table(myData_simple, "./myData/myData_simple.txt", row.names=F)

close(con)
