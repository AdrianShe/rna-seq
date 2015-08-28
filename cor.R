## Preprocess data and compute correlations
library(plyr)

## Load matricies into workspace
message("Loading all data")
load("all_matricies.RData")

## x: matrix of expression values in FPKM from RNA-seq quantification tool
processData <- function(x) {
  x[x < 1] <- NA ## Remove values < 1 FPKM
  x <- x * 10^6 / apply(x, 1, sum, na.rm = TRUE)  ## Convert to tpm
  x <- log2(x + 1)   ## Take log2 + 1 transformation
  return(x)
}

message("Processing CCLE Data")
ccle_tophat_cufflinks <- processData(ccle_tophat_cufflinks)
ccle_tophat_stringtie <- processData(ccle_tophat_stringtie)
ccle_star_cufflinks <- processData(ccle_star_cufflinks)
ccle_star_stringtie <- processData(ccle_star_stringtie)
ccle_kallisto <- log2(ccle_kallisto + 1)

message("Processing GNE Data")
gne_tophat_cufflinks <- processData(gne_tophat_cufflinks)
gne_tophat_stringtie <- processData(gne_tophat_stringtie)
gne_star_cufflinks <- processData(gne_star_cufflinks)
gne_star_stringtie <- processData(gne_star_stringtie)
gne_kallisto <- log2(gne_kallisto + 1)

args <- commandArgs(trailingOnly = TRUE)
if (args[1]) {
    ccle_tophat_cufflinks <- t(ccle_tophat_cufflinks)
    ccle_kallisto <- t(ccle_kallisto)
    ccle_star_cufflinks <- t(ccle_star_cufflinks)
    gne_kallisto <- t(gne_kallisto)
    gne_star_cufflinks <- t(gne_star_cufflinks)
    gne_tophat_cufflinks <- t(gne_tophat_cufflinks)
}

## df1: frame 1 of gene expression values in TPM
## df2: frame 2 of gene expression values in TPM
## method: "pearson" or "spearman" correlation
## returns named vector of correlation values
getCorrelation <- function(df1, df2, method) {
  
  ## Get common rows and genes
  commonRows <- intersect(rownames(df1), rownames(df2))
  commonGenes <- intersect(colnames(df1), colnames(df2))
  df1 <- df1[commonRows, commonGenes]
  df2 <- df2[commonRows, commonGenes]
  
  ## Compute correlation by row
  correlation <- sapply(1:nrow(df1), function (x)
    tryCatch(cor(df1[x,], df2[x,], "complete", method), 
            error = function(e) { NA },
            warning = function(w) { NA }))
  correlation <- matrix(correlation, nrow = 1)
  colnames(correlation) <- commonRows
  print(paste(length(commonRows), "found"))
  return(correlation)
}



message("Calculating CCLE correlations")

ccleCorMatrixSpearman <- rbind.fill.matrix(list(
  getCorrelation(ccle_tophat_cufflinks, ccle_star_cufflinks, "spearman"),
  getCorrelation(ccle_kallisto, ccle_tophat_cufflinks, "spearman"),
  getCorrelation(ccle_star_cufflinks, ccle_kallisto, "spearman"),
  getCorrelation(ccle_tophat_cufflinks, ccle_tophat_stringtie, "spearman"),
  getCorrelation(ccle_star_cufflinks, ccle_star_stringtie, "spearman"),
  getCorrelation(ccle_tophat_stringtie, ccle_star_stringtie, "spearman"),
  getCorrelation(ccle_kallisto, ccle_tophat_stringtie, "spearman"),
  getCorrelation(ccle_kallisto, ccle_star_stringtie, "spearman")))

ccleCorMatrixPearson <- rbind.fill.matrix(list(
  getCorrelation(ccle_tophat_cufflinks, ccle_star_cufflinks, "pearson"),
  getCorrelation(ccle_kallisto, ccle_tophat_cufflinks, "pearson"),
  getCorrelation(ccle_star_cufflinks, ccle_kallisto, "pearson"),
  getCorrelation(ccle_tophat_cufflinks, ccle_tophat_stringtie, "pearson"),
  getCorrelation(ccle_star_cufflinks, ccle_star_stringtie, "pearson"),
  getCorrelation(ccle_tophat_stringtie, ccle_star_stringtie, "pearson"),
  getCorrelation(ccle_kallisto, ccle_tophat_stringtie, "pearson"),
  getCorrelation(ccle_kallisto, ccle_star_stringtie, "pearson")))


gneCorMatrixSpearman <- rbind.fill.matrix(list(
  getCorrelation(gne_tophat_cufflinks, gne_star_cufflinks, "spearman"),
  getCorrelation(gne_kallisto, gne_tophat_cufflinks, "spearman"),
  getCorrelation(gne_star_cufflinks, gne_kallisto, "spearman"),
  getCorrelation(gne_tophat_cufflinks, gne_tophat_stringtie, "spearman"),
  getCorrelation(gne_star_cufflinks, gne_star_stringtie, "spearman"),
  getCorrelation(gne_tophat_stringtie, gne_star_stringtie, "spearman"),
  getCorrelation(gne_kallisto, gne_tophat_stringtie, "spearman"),
  getCorrelation(gne_kallisto, gne_star_stringtie, "spearman")))

gneCorMatrixPearson <- rbind.fill.matrix(list(
  getCorrelation(gne_tophat_cufflinks, gne_star_cufflinks, "pearson"),
  getCorrelation(gne_kallisto, gne_tophat_cufflinks, "pearson"),
  getCorrelation(gne_star_cufflinks, gne_kallisto, "pearson"),
  getCorrelation(gne_tophat_cufflinks, gne_tophat_stringtie, "pearson"),
  getCorrelation(gne_star_cufflinks, gne_star_stringtie, "pearson"),
  getCorrelation(gne_tophat_stringtie, gne_star_stringtie, "pearson"),
  getCorrelation(gne_kallisto, gne_tophat_stringtie, "pearson"),
  getCorrelation(gne_kallisto, gne_star_stringtie, "pearson")))

message("Calculating study correlations")
studyCorMatrixSpearman <- rbind.fill.matrix(list(
  getCorrelation(ccle_tophat_cufflinks, gne_tophat_cufflinks, "spearman"),
  getCorrelation(ccle_star_cufflinks, gne_star_cufflinks, "spearman"),
  getCorrelation(ccle_kallisto, gne_kallisto, "spearman"),
  getCorrelation(ccle_tophat_stringtie, gne_tophat_stringtie, "spearman"),
  getCorrelation(ccle_star_stringtie, gne_star_stringtie, "spearman")))

studyCorMatrixPearson <- rbind.fill.matrix(list(
	getCorrelation(ccle_tophat_cufflinks, gne_tophat_cufflinks, "pearson"),
 	getCorrelation(ccle_star_cufflinks, gne_star_cufflinks, "pearson"),
	getCorrelation(ccle_kallisto, gne_kallisto, "pearson"),
	getCorrelation(ccle_tophat_stringtie, gne_tophat_stringtie, "pearson"),
	getCorrelation(ccle_star_stringtie, gne_star_stringtie, "pearson")))

## TODO: Different cell lines in CCLE v_ GNE
## Gene reproducbility among cell lines and methods with can quantify
## gene-level expression

save(studyCorMatrixSpearman, studyCorMatrixPearson, gneCorMatrixSpearman, gneCorMatrixPearson,
ccleCorMatrixSpearman, ccleCorMatrixPearson, file = "corMatricies_aug28.RData")
  
