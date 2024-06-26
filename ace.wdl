version 1.0


workflow ace {
input {
  File inputBamFile
  String outputFileNamePrefix
  String reference
}


call runAce { 
  input: 
  bamFile = inputBamFile,  
  modules = "ace/1.20.0",
  genome =  reference,
  outputFileNamePrefix = outputFileNamePrefix
}

parameter_meta {
  inputBamFile: "Input BAM file with aligned RNAseq reads."
  outputFileNamePrefix: "Output prefix, customizable. Default is the input file's basename."
  reference: "Name and version of reference genome"
}

output {
  File resultZip = runAce.resultZip
}


meta {
  author: "Gavin Peng"
  email: "gpeng@oicr.on.ca"
  description: "ace, workflow for absolute copy number estimation from low-coverage whole-genome sequencing data"
  dependencies: [
      {
        name: "ace/1.20.0",
        url: "https://github.com/tgac-vumc/ACE"
      }
    ]
    output_meta: {
    resultZip: {
        description: "Zipped folder for all outputs",
        vidarr_label: "resultZip"
    }
}
}

}

task runAce {
input {
  File bamFile
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


runACE(inputdir = "./", outputdir = "./result", filetype='bam', genome = "~{genome}", binsizes = ~{binsizes}, ploidies = ~{ploidies}, imagetype= "~{imagetype}", method = "~{method}", penalty = ~{penalty}, trncname = ~{trncname}, printsummaries = ~{printsummaries}) 


files2zip <- dir('./result', full.names = TRUE)
zip(zipfile = paste('~{outputFileNamePrefix}','resultZip', sep='_'), files = files2zip)

CODE
>>>

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File resultZip = "~{outputFileNamePrefix}"+"_resultZip.zip"
}
}
