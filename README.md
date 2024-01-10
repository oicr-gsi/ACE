# ACE

ACE, workflow for absolute copy number estimation from low-coverage whole-genome sequencing data

## Overview

## Dependencies

* [ace 1.20.0](https://github.com/tgac-vumc/ACE)


## Usage

### Cromwell
```
java -jar cromwell.jar run ACE.wdl --inputs inputs.json
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
`runACE.binsizes`|String|"c(30, 50, 100, 500, 1000)"|The vector of disired bin sizes for bam files
`runACE.ploidies`|String|"c(2,3,4)"|Specifies for which ploidies fits will be made
`runACE.imagetype`|String|"png"|The image file type to create
`runACE.method`|String|"RMSE"|A standard method for error calculation, default is the root mean squared error (RMSE)
`runACE.penalty`|String|0.1|Penalty for the error calculated at lower cellularity
`runACE.trncname`|String|"FALSE"| Whether truncate name, which truncates the name to everything before the first instance of _
`runACE.printsummaries`|String|"TRUE"|super big summary files may crash the program, so you can set this argument to FALSE
`runACE.timeout`|Int|8|Timeout in hours, needed to override imposed limits
`runACE.jobMemory`|Int|24|Memory in Gb for this job


### Outputs

Output | Type | Description
---|---|---
`zipFolder100k`|File|Zipped folder for 100kbp bin size output
`zipFolder500k`|File|Zipped folder for 500kbp bin size output
`zipFolder1000k`|File|Zipped folder for 1000kbp bin size output


## Commands
  This section lists command(s) run by WORKFLOW workflow
  
  * Running WORKFLOW ACE
 
 ```
  R --no-save<<CODE
  library(ACE)
  library(Biobase)
  library(QDNAseq)
  library(QDNAseq.hg38)
  library(QDNAseq.hg19)
  library(ggplot2)
  
  file.symlink("~{bamFile}", "./")
  fileName = basename("~{bamFile}")
  sampleName = tools::file_path_sans_ext(fileName)
  
  runACE(inputdir = "./", outputdir = "./", filetype='bam', genome = "~{genome}", binsizes = ~{binsizes}, ploidies = ~{ploidies}, imagetype= "~{imagetype}", method = "~{method}", penalty = ~{penalty}, trncname = ~{trncname}, printsummaries = ~{printsummaries}) 
  
  files2zip <- dir('100kbp/2N/likelyfits', full.names = TRUE)
  zip(zipfile = '100k2NLikelyfits', files = files2zip)
  files2zip <- dir('100kbp/4N/likelyfits', full.names = TRUE)
  zip(zipfile = '100k4NLikelyfits', files = files2zip)
  files2zip <- dir('1000kbp/2N/likelyfits', full.names = TRUE)
  zip(zipfile = '1000k2NLikelyfits', files = files2zip)
  files2zip <- dir('1000kbp/4N/likelyfits', full.names = TRUE)
  zip(zipfile = '1000k4NLikelyfits', files = files2zip)
  files2zip <- dir(paste('100kbp/2N/', sampleName, sep=''), full.names = TRUE)
  zip(zipfile = '100k2NSampleFolder', files = files2zip)
  files2zip <- dir(paste('100kbp/4N/', sampleName, sep=''), full.names = TRUE)
  zip(zipfile = '100k4NSampleFolder', files = files2zip)
  files2zip <- dir(paste('1000kbp/2N/', sampleName, sep=''), full.names = TRUE)
  zip(zipfile = '1000k2NSampleFolder', files = files2zip)
  files2zip <- dir(paste('1000kbp/4N/', sampleName, sep=''), full.names = TRUE)
  zip(zipfile = '1000k4NSampleFolder', files = files2zip)
  CODE
  >>>
  ``` ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
