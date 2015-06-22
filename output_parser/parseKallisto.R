library(pbapply)

args <- commandArgs(trailingOnly = TRUE)
dir <- "kallisto_runs"  ## Directory of files where files are located

## get files from given directory with kallisto files 
files <- list.files(dir, recursive = TRUE)
resFiles <- grep("abundance.txt", files)
resFiles <- files[resFiles]

## Read files and convert to matrix form
message("Reading abundance.txt files from kallisto output.")
resFrames <- pblapply(1:length(resFiles), function (x) read.delim(paste0(dir, "/", resFiles[x])))
names(resFrames) <- resFiles

message("Creating kallisto matrix")
matrix <- do.call("rbind", lapply(resFrames, function (x) x$tpm))
colnames(matrix) <- resFrames[[1]]$target_id
rownames(matrix) <- sapply(rownames(matrix), function (x) gsub("abundance.txt", "", x))

## Extract CCLE/GNE matricies aand remove them from row names
message("Making matricies for each study")
ccleMatrix <- matrix[grep("CCLE", rownames(matrix)),]
gneMatrix <- matrix[grep("GNE", rownames(matrix)),]
rownames(ccleMatrix) <- sapply(rownames(ccleMatrix), function (x) gsub("/CCLE/", "", x))
rownames(gneMatrix) <- sapply(rownames(gneMatrix), function (x) gsub("/GNE/", "", x))
save(ccleMatrix, gneMatrix, file = "kallistoMatricies.RData")

message("Writing csvs")
write.csv(ccleMatrix, file = "ccle_kallisto_res.csv")
write.csv(gneMatrix, file = "gne_kallisto_res.csv")
#save(resFrames, file = "readFrames.RData")
