# RefImpute release V4

## Description: 
### Panel
 - X loci
 - Y samples
 - Chromosomes: 1-22
 -  SNPs and Indels with '`--min-ac 3`' and '`--max-alleles 2`'
 - Populations:
   - XXX (m samples)
   - YYY (n samples)

## Link to calling pipeline

## Steps:
### 01_clean.sh
  - remove 'trypanogen12' (duplicates and low QC)
  - remove all INFO and FORMAT fields except
   - ^INFO/DP
   - ^INFO/QD
   - ^INFO/VQSLOD

### 02_add_rsids.sh
 - annotate with latest dbSNP:
   - downloaded latest dbSNP from [here](https://ftp.ncbi.nlm.nih.gov/snp/latest_release/VCF/)
     - latest version is 154, which has 729,491,867 rsIDs
     - first rename the chromosomes in the dbSNP vcf. They have names like 'NC_000006.11' for '6' ([biostars answer](https://www.biostars.org/p/98582/#332269))
     
       ```   bcftools annotate --rename-chrs chr_name_conv.txt```
   - [Suggested](https://www.biostars.org/p/227652/#227663) tool for annotating rsIDS was [SNPSift](https://pcingola.github.io/SnpEff/ss_annotate/)
  
    ```java -jar SnpSift.jar annotate dbSnp132.vcf variants.vcf```

### 03_filter.sh
 - keep only vcf lines that:
  - have 2 alleles
  - minor allele count > 2
  - is "snp" or "indel"



