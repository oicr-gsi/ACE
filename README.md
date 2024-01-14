# ACE

ACE, workflow for absolute copy number estimation from low-coverage whole-genome sequencing data

## Overview
ACE is a an absolute copy number estimator that scales copy number data to fit with integer copy numbers.
For this it uses segmented data from the QDNAseq package, which in turn uses a number of dependencies.
Note: make sure QDNAseq fetches the bin annotations from the same genome build as the one used for
aligning the sequencing data!

In brief: ACE will run QDNAseq or use its output rds-file(s)
of segmented data. It will subsequently run through all samples in the object(s), for which it will create
individual subdirectories. For each sample, it will calculate how well the segments fit (the relative error)
to integer copy numbers for each percentage of “tumor cells” (cells with divergent segments). Note that it
does not estimate for a lower percentage than 5. ACE will output a graph with relative errors (all errors
relative to the largest error). Said graph can be used to quickly identify the most likely fit. ACE selects all
“minima” and saves the corresponding copy number plots. The “best fit” (lowest error) is not by definition
the most likely fit! ACE will run models for a general tumor ploidy of 2N, but you can expand this to include
any ploidy of your choosing. The program needs to make one assumption: the median bin segment value
corresponds with the tumor’s general ploidy.

### ACE output
**rds-file**
This is the segmented QDNAseq object; obviously not created when using rds-file as input. It can be used if
you want to run ACE again with slightly different parameters. More importantly, you can use this file to
examine individual samples in downstream analyses.

**rds subdirectories**
ACE creates a subdirectory for each rds-file. In case of bam-files as input, the subdirectories have the names
of the binsizes.

**ploidies subdirectories**
For each analyzed tumor ploidy, ACE makes a subdirectory. In this case: 2N and 4N

**summaries**
summary_errors: error lists of all the models summary_likelyfits: copy number plots of the best fit and the
last minimum of each sample, with the corresponding error list plots. I would recommend using the likelyfits
for model selection. Summary files can become quite big / huge depending on sample size and bin size. See
below how to deal with this.

**likelyfits subdirectory**
This subdirectory contains the individual copy number graphs of the likelyfits.
2individual sample subdirectories
These subdirectories have a summary file with all the fits for the corresponding sample and the error list plot.
Individual copy number graphs are available in the subdirectory “graphs”.

**fitpicker tables**
This tab-delimited file can be used during selection of most likely models. Especially handy when analyzing a
large number of samples. 

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
`runACE.binsizes`|String|"c(100, 500, 1000)"|The vector of disired bin sizes for bam files
`runACE.ploidies`|String|"c(2,3,4)"|Specifies for which ploidies fits will be made
`runACE.imagetype`|String|"pdf"|The image file type to create
`runACE.method`|String|"RMSE"|A standard method for error calculation, default is the root mean squared error (RMSE)
`runACE.penalty`|String|0.1|Penalty for the error calculated at lower cellularity
`runACE.trncname`|String|"FALSE"| Whether truncate name, which truncates the name to everything before the first instance of _
`runACE.printsummaries`|String|"TRUE"|super big summary files may crash the program, so you can set this argument to FALSE
`runACE.timeout`|Int|8|Timeout in hours, needed to override imposed limits
`runACE.jobMemory`|Int|24|Memory in Gb for this job


### Outputs

Output | Type | Description
---|---|---
`resultZip`|File|Zipped folder for all outputs


## Commands
 This section lists command(s) run by ACE workflow
 
 * Running ACE
 
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
