## Parse output for stringtie
library(data.table)
library(pbapply)

parseStringtieFile <- function(file) {
  lines <- read.delim(file, header = FALSE, skip = 2, colClasses=c(rep("character", 3), rep("integer", 3), rep("character", 3)), nrows=1200000)
  ## Get lines with an FPKM value and a reference annotation
  info <- as.character(lines[,9])
  lines <- lines[grep("FPKM", info),]
  annotatedLines <- lines[grep("reference_id", as.character(lines[,9])),]

  ## Get tokens from ; info
  tokens <- strsplit(as.character(annotatedLines[, 9]), ";")
  transcript_id <- sapply(tokens, function (x) gsub(" reference_id ", "", x[3]))
  FPKM <- sapply(tokens, function (x) as.numeric(gsub(" FPKM ", "", x[7])))
  names(FPKM) <- transcript_id
  return(FPKM)
}

isComplete <- function(x) {
  length(readLines(x, 3)) > 2
}

##
args <- commandArgs()
print(args)
path <- args[1] ## hack to make this work properly
align <- args[2]
files <- list.files(path, full.names  = TRUE)
files_ccle <- sapply(files, function (x) paste0(x, "/CCLE/stringtie_output.gtf"))
#files_gne <- sapply(files, function (x) paste0(x, "/GNE/stringtie_output.gtf"))

files_ccle_comp <- Filter(file.exists, files_ccle)
files_ccle_comp <- Filter(isComplete, files_ccle_comp)
print(paste("Problematic dirs or no StringTie output: ", setdiff(files_ccle, files_ccle_comp)))
print(paste(length(files_ccle_comp), "CCLE files to process"))

#files_gne_comp <- Filter(file.exists, files_gne)
#files_gne_comp <- Filter(isComplete, files_gne_comp)
#print(paste("Problematic dirs or no StringTie output: ", setdiff(files_gne, files_gne_comp)))
#print(paste(length(files_gne_comp), "GNE files to process"))

message("Parsing CCLE output files")
parsedLines_ccle  <- pblapply(files_ccle_comp, parseStringtieFile)
names(parsedLines_ccle) <- files_ccle_comp

#message("Parsing GNE output files")
#parsedLines_gne  <- pblapply(files_gne_comp, parseStringtieFile)
#names(parsedLines_gne) <- files_gne_comp

save(parsedLines_ccle, file = paste0(align, "_ccle_stringtie_res.RData"))



