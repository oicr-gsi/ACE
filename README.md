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
`runACE.binsizes`|String|"c(100, 1000)"|The vector of disired bin sizes for bam files
`runACE.ploidies`|String|"c(2,4)"|Specifies for which ploidies fits will be made
`runACE.imagetype`|String|"png"|The image file type to create
`runACE.method`|String|"RMSE"|A standard method for error calculation, default is the root mean squared error (RMSE)
`runACE.penalty`|String|0|Penalty for the error calculated at lower cellularity
`runACE.trncname`|String|"FALSE"| Whether truncate name, which truncates the name to everything before the first instance of _
`runACE.printsummaries`|String|"TRUE"|super big summary files may crash the program, so you can set this argument to FALSE
`runACE.timeout`|Int|8|Timeout in hours, needed to override imposed limits
`runACE.jobMemory`|Int|24|Memory in Gb for this job


### Outputs

Output | Type | Description
---|---|---
`SummaryError100k2N`|File|Error lists of all the models of 100k binsize and 2N ploidy
`SummaryError100k4N`|File|Error lists of all the models of 100k binsize and 4N ploidy
`SummaryLikelyfits100k2N`|File|Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 100k binsize and 2N ploidy
`SummaryLikelyfits100k4N`|File|Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 100k binsize and 2N ploidy
`SummaryError1000k2N`|File|Error lists of all the models of 1000k binsize and 2N ploidy
`SummaryError1000k4N`|File|Error lists of all the models of 100k binsize and 4N ploidy
`SummaryLikelyfits1000k2N`|File|Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 1000k binsize and 2N ploidy
`SummaryLikelyfits1000k4N`|File|Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 1000k binsize and 4N ploidy
`Fitpicker100k2N`|File|Tab-delimited file used during selection of most likely models. For 100k binsize and 2N ploidy
`Fitpicker100k4N`|File|Tab-delimited file used during selection of most likely models. For 100k binsize and 4N ploidy
`Fitpicker1000k2N`|File|Tab-delimited file used during selection of most likely models. For 1000k binsize and 2N ploidy
`Fitpicker1000k4N`|File|Tab-delimited file used during selection of most likely models. For 1000k binsize and 4N ploidy
`Likelyfits100k2N`|File|Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 100k binsize and 2N ploidy
`Likelyfits100k4N`|File|Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 100k binsize and 4N ploidy
`Likelyfits1000k2N`|File|Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 1000k binsize and 2N ploidy
`Likelyfits1000k4N`|File|Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 1000k binsize and 4N ploidy
`SampleFolder100k2N`|File|Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 100k binsize and 2N ploidy
`SampleFolder100k4N`|File|Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 100k binsize and 4N ploidy
`SampleFolder1000k2N`|File|Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 1000k binsize and 2N ploidy
`SampleFolder100044N`|File|Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 1000k binsize and 4N ploidy


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
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
