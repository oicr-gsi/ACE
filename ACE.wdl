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
  File zipFolder100k = runACE.zipFolder100k
  File zipFolder500k = runACE.zipFolder500k
  File zipFolder1000k = runACE.zipFolder1000k
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
  zipFolder100k: "Zipped folder for 100kbp bin size output",
  zipFolder500k: "Zipped folder for 500kbp bin size output",
  zipFolder1000k: "Zipped folder for 1000kbp bin size output"
  }
}

}

task runACE {
input {
  File bamFile
  String aceScript
  String outputFileNamePrefix
  String genome
  String binsizes = "c(100, 500, 1000)"
  String ploidies = "c(2,3,4)"
  String imagetype = "pdf"
  String method = "RMSE"
  String penalty = 0.1
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


runACE(inputdir = "./", outputdir = "./", filetype='bam', genome = "~{genome}", binsizes = ~{binsizes}, ploidies = ~{ploidies}, imagetype= "~{imagetype}", method = "~{method}", penalty = ~{penalty}, trncname = ~{trncname}, printsummaries = ~{printsummaries}) 


files2zip <- dir('./500kbp', full.names = TRUE)
zip(zipfile = paste('~{outputFileNamePrefix}','500kbp', sep='_'), files = files2zip)
files2zip <- dir('./100kbp', full.names = TRUE)
zip(zipfile = paste('~{outputFileNamePrefix}','100kbp', sep='_'), files = files2zip)
files2zip <- dir('./1000kbp', full.names = TRUE)
zip(zipfile = paste('~{outputFileNamePrefix}','1000kbp', sep='_'), files = files2zip)

CODE
>>>

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File zipFolder100k = "~{outputFileNamePrefix}"+"_100kbp.zip"
  File zipFolder500k = "~{outputFileNamePrefix}"+"_500kbp.zip"
  File zipFolder1000k = "~{outputFileNamePrefix}"+"_1000kbp.zip"
}
}
