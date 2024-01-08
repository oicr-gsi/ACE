version 1.0


workflow ACE {
input {
  File inputBamFile
  String outputFileNamePrefix
  String reference
}


call runACE { 
  input: 
  bamFile = inputBamFile,  
  modules = "ace/1.20.0",
  aceScript = "$ACE_ROOT/share/R/ACE.R",
  genome =  reference,
  outputFileNamePrefix = outputFileNamePrefix
}

parameter_meta {
  inputBamFile: "Input BAM file with aligned RNAseq reads."
  outputFileNamePrefix: "Output prefix, customizable. Default is the input file's basename."
  reference: "Name and version of reference genome"
}

output {
  File SummaryError100k2N = runACE.SummaryError100k2N 
  File SummaryError100k4N = runACE.SummaryError100k4N 
  File SummaryLikelyfits100k2N = runACE.SummaryLikelyfits100k2N
  File SummaryLikelyfits100k4N = runACE.SummaryLikelyfits100k4N
  File SummaryError1000k2N = runACE.SummaryError1000k2N
  File SummaryError1000k4N = runACE.SummaryError1000k4N
  File SummaryLikelyfits1000k2N = runACE.SummaryLikelyfits1000k2N
  File SummaryLikelyfits1000k4N = runACE.SummaryLikelyfits1000k4N
  File Fitpicker100k2N = runACE.Fitpicker100k2N
  File Fitpicker100k4N = runACE.Fitpicker100k4N
  File Fitpicker1000k2N = runACE.Fitpicker1000k2N
  File Fitpicker1000k4N = runACE.Fitpicker1000k4N
  File Likelyfits100k2N = runACE.Likelyfits100k2N
  File Likelyfits100k4N = runACE.Likelyfits100k4N
  File Likelyfits1000k2N = runACE.Likelyfits1000k2N
  File Likelyfits1000k4N = runACE.Likelyfits1000k4N
  File SampleFolder100k2N = runACE.SampleFolder100k2N
  File SampleFolder100k4N = runACE.SampleFolder100k2N
  File SampleFolder1000k2N = runACE.SampleFolder1000k2N
  File SampleFolder100044N = runACE.SampleFolder1000k4N
}

meta {
  author: "Gavin Peng"
  email: "gpeng@oicr.on.ca"
  description: "ACE, workflow for absolute copy number estimation from low-coverage whole-genome sequencing data"
  dependencies: [
      {
        name: "ace/1.20.0",
        url: "https://github.com/tgac-vumc/ACE"
      }
    ]
  output_meta: {
  SummaryError100k2N: "Error lists of all the models of 100k binsize and 2N ploidy",
  SummaryError100k4N: "Error lists of all the models of 100k binsize and 4N ploidy",
  SummaryLikelyfits100k2N: "Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 100k binsize and 2N ploidy",
  SummaryLikelyfits100k4N: "Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 100k binsize and 2N ploidy",
  SummaryError1000k2N: "Error lists of all the models of 1000k binsize and 2N ploidy",
  SummaryError1000k4N: "Error lists of all the models of 100k binsize and 4N ploidy",
  SummaryLikelyfits1000k2N: "Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 1000k binsize and 2N ploidy",
  SummaryLikelyfits1000k4N: "Copy number plots of the best fit and the last minimum of each sample, with the corresponding error list plots. For 1000k binsize and 4N ploidy",
  Fitpicker100k2N: "Tab-delimited file used during selection of most likely models. For 100k binsize and 2N ploidy",
  Fitpicker100k4N: "Tab-delimited file used during selection of most likely models. For 100k binsize and 4N ploidy",
  Fitpicker1000k2N: "Tab-delimited file used during selection of most likely models. For 1000k binsize and 2N ploidy",
  Fitpicker1000k4N: "Tab-delimited file used during selection of most likely models. For 1000k binsize and 4N ploidy",
  Likelyfits100k2N: "Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 100k binsize and 2N ploidy",
  Likelyfits100k4N: "Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 100k binsize and 4N ploidy",
  Likelyfits1000k2N: "Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 1000k binsize and 2N ploidy",
  Likelyfits1000k4N: "Zip of subdirectory contains the individual copy number graphs of the likelyfits. For 1000k binsize and 4N ploidy",
  SampleFolder100k2N: "Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 100k binsize and 2N ploidy",
  SampleFolder100k4N: "Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 100k binsize and 4N ploidy",
  SampleFolder1000k2N: "Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 1000k binsize and 2N ploidy",
  SampleFolder100044N: "Zip file of individual sample subdirectories, have a summary file with all the fits for the corresponding sample and the error list plot. Individual copy number graphs are available in the subdirectory 'graphs'. For 1000k binsize and 4N ploidy"
  }
}

}

task runACE {
input {
  File bamFile
  String aceScript
  String outputFileNamePrefix
  String genome
  String binsizes = "c(100, 1000)"
  String ploidies = "c(2,4)"
  String imagetype = "png"
  String method = "RMSE"
  String penalty = 0
  String trncname = "FALSE"
  String printsummaries = "TRUE"
  String modules
  Int timeout = 8
  Int jobMemory = 24
}

parameter_meta {
 bamFile: "Input .bam file for analysis sample"
 aceScript: "The R script to run ACE"
 outputFileNamePrefix: "Prefix of output files"
 genome: "the genome version for bam build"
 binsizes: "The vector of disired bin sizes for bam files"
 ploidies: "Specifies for which ploidies fits will be made"
 imagetype: "The image file type to create"
 method: "A standard method for error calculation, default is the root mean squared error (RMSE)"
 penalty: "Penalty for the error calculated at lower cellularity"
 printsummaries: "super big summary files may crash the program, so you can set this argument to FALSE"
 trncname: " Whether truncate name, which truncates the name to everything before the first instance of _"
 jobMemory: "Memory in Gb for this job"
 modules: "Names and versions of modules"
 timeout: "Timeout in hours, needed to override imposed limits"
}

command <<<
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

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File SummaryError100k2N = "./100kbp/2N/summary_errors.png"
  File SummaryLikelyfits100k2N = "./100kbp/2N/summary_likelyfits.png"
  File SummaryError100k4N = "./100kbp/4N/summary_errors.png"
  File SummaryLikelyfits100k4N = "./100kbp/4N/summary_likelyfits.png"
  File SummaryError1000k2N = "./1000kbp/2N/summary_errors.png"
  File SummaryLikelyfits1000k2N = "./1000kbp/2N/summary_likelyfits.png"
  File SummaryError1000k4N = "./1000kbp/4N/summary_errors.png"
  File SummaryLikelyfits1000k4N = "./1000kbp/4N/summary_likelyfits.png"
  File Fitpicker100k2N = "100kbp/2N/fitpicker_2N.tsv"
  File Fitpicker100k4N = "100kbp/4N/fitpicker_4N.tsv"
  File Fitpicker1000k2N = "1000kbp/2N/fitpicker_2N.tsv"
  File Fitpicker1000k4N = "1000kbp/4N/fitpicker_4N.tsv"
  File Likelyfits100k2N = "./100k2NLikelyfits.zip"
  File Likelyfits100k4N = "./100k4NLikelyfits.zip"
  File Likelyfits1000k2N = "./1000k2NLikelyfits.zip"
  File Likelyfits1000k4N = "./1000k4NLikelyfits.zip"
  File SampleFolder100k2N = "./100k2NSampleFolder.zip"
  File SampleFolder100k4N = "./100k4NSampleFolder.zip"
  File SampleFolder1000k2N = "./1000k2NSampleFolder.zip"
  File SampleFolder1000k4N = "./1000k4NSampleFolder.zip"
}
}
