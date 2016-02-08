### Genome-wide association studies and personality SNPs

This repository contains: 

2x .R R scripts: genes2personality.R and my23andMe.R

2x .txt files: genes2personality.txt, genes2personalityV2.txt

More information about these files can be found in Codebook.md 

The R scripts were developed under R version 3.2.3 (2015-12-10), R Studio Version 0.99.489 and Window 8.1 x64 bit. 

The my23andMe.R script takes two inputs: the genes2personalityV2.txt dataset, which contains personality-related SNPs identified in genome-wide association studies and curated in the [NHGRI-EBI Catalog] (http://www.ebi.ac.uk/gwas/docs/downloads), and a raw genotype file returned by 23andMe or FTDNA (a .txt or .csv file with four columns in the following order: rsid, chromosome, position, genotypes), and merges them together so that a person's personality-related SNPs are returned.    

#### Simple use: 

1. Download the latest version of R (r-base only) from the official site: [R-project](https://cran.r-project.org/). 

If you run into trouble, follow the instructions found in these platform-specific videos:

[Windows](https://www.youtube.com/watch?v=Ohnk9hcxf9M) 
[Mac OS](https://www.youtube.com/watch?v=uxuuWXU-7UQ)

2. Optional: download R-studio (makes life easier): [R studio](https://www.rstudio.com/)

3. Open R or R-studio and in the R-console (after the > prompt) type: 

> con<- url("https://raw.githubusercontent.com/dencook/genes2personality/master/my23andMe.R")

> source(con)

The first time through, the script will attempt to download the necessary packages from the r-studio cloud repository, if they are not already installed. Several dependencies will be installed as well. If a prompt comes up asking you if you'd like to save to a personal library instead, type y. 

The script will then create a folder called myData in your working directory, download the genes2personalityV2 dataset and ask you to add your raw 23andMe dataset (.txt file) (or FTDNA .csv file) to the myData folder and rename it YourName_myData. To find your working directory, type getwd(). 

Once you've copied over your SNP data, source the script again: 

> source(con)
 
If everything worked out well, you should have two files called myData and myData.simple in the myData folder. The myData.simple file contains your personality trait-related genotypes (found under YourName), along with the trait allele associated with the particular personality trait, the two alleles at that site, and the gene name. 

The myData file contains more extensive documentation, including the author/date/journal that reported the associations, the ancestral allele, the chromosome number and the SNP position. 

Note: this script is capable of merging multiple raw genotype files at once, as long as they all have unique YourName_myData file names. However, the time for data processing slows significantly with > 2 files, although I'm still talking in the low minutes (< 4 minutes for 8 files). Once you merge many datasets together, R will replace any RsIDs not tested for a particular person with "NA". V4 contains by far the greatest number of these personality-trait SNPs (and 23andMe in general (V2-V3) has greater numbers of these SNPs than FTDNA and Ancestry). 

     

