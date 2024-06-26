# ace

ace, workflow for absolute copy number estimation from low-coverage whole-genome sequencing data

## Overview

## Dependencies

* [ace 1.20.0](https://github.com/tgac-vumc/ACE)


## Usage

### Cromwell
```
java -jar cromwell.jar run ace.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`inputBamFile`|File|Input BAM file with aligned RNAseq reads.
`outputFileNamePrefix`|String|Output prefix, customizable. Default is the input file's basename.
`reference`|String|Name and version of reference genome


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runAce.binsizes`|String|"c(100, 500, 1000)"|The vector of disired bin sizes for bam files
`runAce.ploidies`|String|"c(2,3,4)"|Specifies for which ploidies fits will be made
`runAce.imagetype`|String|"pdf"|The image file type to create
`runAce.method`|String|"RMSE"|A standard method for error calculation, default is the root mean squared error (RMSE)
`runAce.penalty`|String|0.1|Penalty for the error calculated at lower cellularity
`runAce.trncname`|String|"FALSE"| Whether truncate name, which truncates the name to everything before the first instance of _
`runAce.printsummaries`|String|"TRUE"|super big summary files may crash the program, so you can set this argument to FALSE
`runAce.timeout`|Int|8|Timeout in hours, needed to override imposed limits
`runAce.jobMemory`|Int|24|Memory in Gb for this job


### Outputs

Output | Type | Description | Labels
---|---|---|---
`resultZip`|File|Zipped folder for all outputs|vidarr_label: resultZip


## Commands
 This section lists command(s) run by ace workflow
 
 * Running ace
 
 ```
 R --no-save<<CODE
 library(ACE)
 library(Biobase)
 library(QDNAseq)
 library(QDNAseq.hg38)
 library(QDNAseq.hg19)
 library(ggplot2)
 
 file.symlink("~{bamFile}", "./")
 
 
 runACE(inputdir = "./", outputdir = "./result", filetype='bam', genome = "~{genome}", binsizes = ~{binsizes}, ploidies = ~{ploidies}, imagetype= "~{imagetype}", method = "~{method}", penalty = ~{penalty}, trncname = ~{trncname}, printsummaries = ~{printsummaries}) 
 
 
 files2zip <- dir('./result', full.names = TRUE)
 zip(zipfile = paste('~{outputFileNamePrefix}','resultZip', sep='_'), files = files2zip)
 
 CODE
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
