#This script downloads the publicly-accessible NHGRI-EBI Catalog of published genome-wide association studies,  #available in several different formats here: http://www.ebi.ac.uk/gwas/docs/downloads. This script will automatically #download the most recent edition of the Catalog WITHOUT added annotations, into a directory it creates called #myData.  

#loads required packages, downloads packages if necessary. data.table and dplyr for increased speed with large #datasets

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

library(data.table); library(dplyr)  

#creates a directory for the GWAS and 23andMe_key files in your current working directory
if (!file.exists("./myData")){dir.create("./myData")}

#downloads the 23andMe SNP key found in the documentation for the API: https://api.23andme.com/docs/reference/. Note #that this file contains > 1 million SNPs, which means it represents all the SNPs they have ever tested for (not just #the current V4)

if (!file.exists("./myData/my23andMe_key.txt")) {
  fileUrl<- "https://api.23andme.com/res/txt/snps.b4e00fe1db50.data"
  download.file(fileUrl, "./myData/my23andMe_key.txt")
}

#read in the file 1133211 obs of 4 variables
my23andMe_key<-fread("./myData/my23andMe_key.txt", colClasses="character")
#record the date of download
date_23andMe<-date()

#download GWAS dataset
if (!file.exists("./myData/GWAS.tsv")) {
  fileUrl<- "http://www.ebi.ac.uk/gwas/api/search/downloads/full"
  download.file(fileUrl, "./myData/GWAS.tsv")
}

#read in the GWAS file 24457 obs. of 34 variables
GWAS<-read.delim("./myData/GWAS.tsv", colClasses="character")
#record the date of download
date_GWAS<-date()

#Select only the rows containing SNPs associated with personality dimensions and temperament. Note that if you wanted #to use this script to subset the data in your own way, this would be where you could do it. This also selects only the #columns I'm interested in keeping. 57 obs. of 9 variables  
personality<- GWAS %>%
  filter(DISEASE.TRAIT %in% c("Temperament", "Personality dimensions", "Common traits (Other)")) %>%
  select(contains("FIRST"), DATE, contains("JOURNAL"), contains("DISEASE"), contains("MAPPED"), contains("STRONGEST"),   SNPS, contains("CONTEXT"), contains("RISK ALLELE"), contains("P.VALUE..TEXT")) 

#remove the brackets from P.VALUE.. column
personality$P.VALUE..TEXT.<-gsub("[()]", "", personality$P.VALUE..TEXT.)

#split the rsID from the risk allele to return only the risk allele
personality$STRONGEST.SNP.RISK.ALLELE<-strsplit(personality$STRONGEST.SNP.RISK.ALLELE, "-")
personality$STRONGEST.SNP.RISK.ALLELE<-sapply(personality$STRONGEST.SNP.RISK.ALLELE, function(x)x[2])

#change SNPS to snp so that we can merge with the 23andMe_key
names(personality)<-sub("SNPS", "snp", names(personality))

#returns a table containing all the GWAS SNPs found associated with some dimension of personality
write.table(personality,"./myData/genes2personality.txt", row.names=FALSE)

#checks how many of those snps are tested by 23andMe (48 obs of 12 variables)
Snps_23andMe<-merge(my23andMe_key, personality, by="snp")

#writes a separate file with the dates of the last dataset download
write.table(c("23andMe_key"=date_23andMe, "NHGRI-EBI_GWAS"=date_GWAS), "./Coursera/test-repo/genes2personality/Download_Dates.txt", col.names=F)
