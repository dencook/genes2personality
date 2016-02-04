#loads required packages, downloads packages if necessary. 
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

library(data.table); library(dplyr)  

if (!file.exists("./GWAS.tsv")) {
  fileUrl<- "http://www.ebi.ac.uk/gwas/api/search/downloads/full"
  download.file(fileUrl, "GWAS.tsv")
}

GWAS<-fread("GWAS.tsv", colClasses="character")
date_GWAS<-date()

personality<- GWAS %>%
  filter(DISEASE.TRAIT %in% c("Temperament", "Personality dimensions", "Common traits (Other)")) %>%
  select(contains("FIRST"), DATE, contains("JOURNAL"), contains("DISEASE"), contains("MAPPED"), contains("STRONGEST"),   SNPS, contains("CONTEXT"), contains("RISK.ALLELE"), contains("P.VALUE..TEXT")) 

personality$P.VALUE..TEXT.<-gsub("[()]", "", personality$P.VALUE..TEXT.)

personality$STRONGEST.SNP.RISK.ALLELE<-strsplit(personality$STRONGEST.SNP.RISK.ALLELE, "-")
personality$STRONGEST.SNP.RISK.ALLELE<-sapply(personality$STRONGEST.SNP.RISK.ALLELE, function(x)x[2])

names(personality)<-sub("SNPS", "snp", names(personality))

write.table(personality,"genes2personality.txt", row.names=FALSE)

