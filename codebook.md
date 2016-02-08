### Codebook to create genes2personality.txt and genes2personalityV2.txt

The genes2personality.R script downloads the publicly-accessible NHGRI-EBI Catalog of published genome-wide association studies, available in several different formats here: [NHGRI-EBI](http://www.ebi.ac.uk/gwas/docs/downloads). The script will automatically download the most recent edition of the Catalog WITHOUT added annotations, into a directory it creates calls myData. 

*Attribution for use of the NHGRI-EBI Catalog in this script goes to:* 

>Burdett T (EBI), Hall PN (NHGRI), Hasting E (EBI) Hindorff LA (NHGRI), Junkins HA (NHGRI), Klemm AK >(NHGRI), MacArthur J (EBI), Manolio TA (NHGRI), Morales J (EBI), Parkinson H (EBI) and Welter D (EBI).
>The NHGRI-EBI Catalog of published genome-wide association studies.
>Available at: www.ebi.ac.uk/gwas. Accessed 02/08/2016, version1.0.

####About the GWAS Catalog (more information available here: [About the NHGRI-EBI Catalog](http://www.ebi.ac.uk/gwas/docs/about))

Catalog stats as of 2016-02-08

* Last data release on 2016-02-06
* 2390 studies
* 14969 SNPs
* 16775 SNP-trait associations
* Genome assembly GRCh38.p2
* dbSNP Build 144

The Catalog has very high selection criteria and is manually curated from published research papers. It only includes studies assaying at least 100,000 SNPs and the associations must have p-values < 1.0 x 10-5 (Hindorff et al., 2009). More information about the Catalog curation process and data extraction procedures can be found here [Methods page](http://www.ebi.ac.uk/gwas/docs/methods).

The full list of available traits in the dataset is available here: [Reported Traits](http://www.ebi.ac.uk/gwas/search/traits)

You can look up individual SNPs, traits, etc, here: [GWAS Catalog](http://www.ebi.ac.uk/gwas/home)

The full list of column names for the GWAS dataset is available here: [column names](http://www.ebi.ac.uk/gwas/docs/fileheaders)

The genes2personality.R script selects the SNPs that match the following disease/traits from the full GWAS Catalog: 

1. Personality Dimensions
2. Temperament
3. Common Traits (other)

It then selects only the following columns: 

1. First Author
2. Date (publication)
3. Journal
4. Disease/Trait
5. Mapped Genes
6. Strongest SNP-risk allele
7. SNPS
8. Context (intergenic, genic, intron, etc)
9. Risk allele frequency
10. P-value (text): information describing context of p-value

The genes2personality.txt file is uploaded to this repository for viewing. 

This file was then taken and converted into a smaller genes2personalityV2.txt file by applying the following changes manually (in the future, most of this should be done through dbSNP):

Alleles, ancestral allele and minor allele frequency were entered manually using the dbSNP database located here: [dbSNP](http://www.ncbi.nlm.nih.gov/projects/SNP/index.html). 

Some column names were changed: 

* Mapped_Gene was replaced with GENE.NAMES
* STRONGEST.SNP.RISK.ALLELE was replaced with TRAIT.ALLELE
* P.VALUE.TEXT was replaced with Personality Trait 

Column Context was deleted. 

The following rows were deleted: 

* All rows where STRONGEST.SNP.RISK.ALLELE = NA or ? 
* All rows from the Eriksson N paper ("Common Traits (other)") 

The genes2personalityV2.txt forms the basis of the merge done with the my23andMe.R script, described in the README.md file. 




  