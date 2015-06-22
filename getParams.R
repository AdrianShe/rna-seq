library(sqldf)

## Read in curation CSVS
if (!file.exists("params.RData")) {
    common <- read.csv("CCLE_GNE_common_profiles.csv", stringsAsFactors = F)
    ccle <- read.csv("ccle_rnaseq_metadata.csv",stringsAsFactors = F)
    gne <- read.csv("gne_rnaseq_metadata.csv",stringsAsFactors = F)

    ## Extract needed info for job submission
    colnames(common) <- gsub("\\.", "_", colnames(common)) ## Use this to fix sql syntax
    common_info <- sqldf("SELECT unique_cellid, ccle_rna_seq_name, gne_rna_seq_name, cells, ccle.dir, analysis_id, file_name, Cell_line, alias FROM common INNER JOIN ccle ON common.ccle_rna_seq_name = ccle.cells INNER JOIN gne ON common.gne_rna_seq_name = gne.Cell_line")
    common_info <- common_info[!duplicated(common_info$unique_cellid),]## remove duplicated profiles s.t. only 460 cell lines remain

    ## Get parameters
    data.dir <- "/mnt/work1/users/bhklab/Data/CCLE/rna_seq"
    dir <- "/mnt/work1/users/bhklab/users/adrian/tophat_runs/"
    CCLE_params <- data.frame(
    "study" = "CCLE", "cell" = common_info$unique_cellid, "fastq1" =paste0(dir, common_info$unique_cellid, "/CCLE/", "CCLE-", common_info$unique_cellid, ".1.fastq"),
    "fastq2" = paste0(dir, common_info$unique_cellid, "/CCLE/", "CCLE-",common_info$unique_cellid, ".2.fastq"),
    "dir" = paste0(data.dir, "/", common_info$dir, "/", common_info$analysis_id, "/", common_info$file_name)
    , stringsAsFactors = F)

    data.dir <- "/mnt/work1/users/bhklab/Data/GNE/rna-seq/EGAD00001000725"
    GNE_params <- data.frame(
    "study" = "GNE", "cell" = common_info$unique_cellid, "fastq1" = paste0(data.dir, "/", common_info$alias, "_1_1.rnaseq.fastq.gz"),
    "fastq2" = paste0(data.dir, "/", common_info$alias, "_1_2.rnaseq.fastq.gz"), stringsAsFactors = F)

    save("CCLE_params", "GNE_params", file = "params.RData")
}

load("params.RData")

fileConn <- file(paste0("jobs", date()))
file_contents <- c("#!/bin/bash")
constructJob <- function(index, study, aligner) {
    params <- switch(study, "CCLE" = CCLE_params[index,], "GNE" = GNE_params[index,])
    jobs <- switch(aligner, "tophat" = constructTophatjob(study, params), "star" = constructStarjob(study, params), "kallisto" = constructKallistoJob(study, params))
    file_contents <- c(file_contents, jobs)
    return(file_contents)
}

constructTophatjob <- function(study, params) {
    job <- "qsub -q bhklab generic_tophat.sh"
    jobs <- sapply(1:nrow(params), function (x) paste(job, paste(params[x,], collapse = " ")))
}

constructStarjob <- function(study, params) {
    job <- "qsub -q bhklab generic_star.sh"
    jobs <- sapply(1:nrow(params), function (x) paste(job, paste(params[x,1:4], collapse = " ")))

}

constructKallistoJob <- function(study, params) {
    job <- "qsub -q bhklab generic_kallisto.sh"
    jobs <- sapply(1:nrow(params), function (x) paste(job, paste(params[x,1:4], collapse = " ")))
}

## Construct jobs here
#sample <- sample(60, 20)
file_contents <- constructJob(52, "CCLE", "tophat")
file_contents <- constructJob(52, "GNE", "tophat")
file_contents <- constructJob(52, "CCLE", "star")
file_contents <- constructJob(52, "GNE", "star")
file_contents <- constructJob(1:60, "CCLE", "kallisto")
file_contents <- constructJob(1:60, "GNE", "kallisto")
file_contents <- constructJob(134, "CCLE", "kallisto")
file_contents <- constructJob(134, "GNE", "kallisto")
file_contents <- constructJob(1, "GNE", "kallisto")
writeLines(file_contents, fileConn)
close(fileConn)



  


