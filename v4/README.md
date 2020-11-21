# RefImpute release V4

## Stats: 

|               | V4a          | V4b          |
| :------------- | :----------: | -----------: |
| Samples        | Y            | y            |
| Chromosomes    | 1-22         | 1-22         |
| Locus types    | snps,indels  | snps,indels  |
| InDels         | Z            | Z            |
| SNPs           | W            | W            |
| Loci           | X            | X            |


### Panel
 - Populations:
   - XXX (m samples)
   - YYY (n samples)

## Link to calling pipeline

## Steps:
### 01_clean.sh
  - remove 'trypanogen12' (duplicates and low QC)
  - remove all INFO and FORMAT fields except (INFO/DP;INFO/QD;INFO/VQSLOD)

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
   - is "snp" or "indel"
   - have 2 alleles and minor allele count >= 3

### suggestions:
 - keep a sites only VCF of each version (not publicly avalailable)
 - extensive stats about SNPs
 - don't filter out the GQ score



![Alt text](https://g.gravizo.com/source/custom_mark13?https%3A%2F%2Fraw.githubusercontent.com%2FTLmaK0%2Fgravizo%2Fmaster%2FREADME.md)
<details> 
<summary></summary>
custom_mark13
@startuml;
actor User;
participant "First Class" as A;
participant "Second Class" as B;
participant "DBAC" as C;
User -> A: DoWork;
activate A;
A -> B: Create Request;
activate B;
B -> C: DoWork;
activate C;
C -> B: WorkDone;
destroy C;
B -> A: Request Created;
deactivate B;
A -> User: Done;
deactivate A;
@enduml
custom_mark13
</details>
