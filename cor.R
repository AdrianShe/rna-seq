## Preprocess data and compute correlations
library(plyr)
#load("/Users/Adrian/Desktop/rna_seq_results/isoforms.RData")

## x: matrix of expression values in FPKM from RNA-seq quantification tool
processData <- function(x) {
  x[x < 1] <- NA ## Remove values < 1 FPKM
  x <- x * 10^6 / apply(x, 1, sum, na.rm = TRUE)  ## Convert to tpm
  x <- log2(x + 1)   ## Take log2 + 1 transformation
  return(x)
}

message("Processing CCLE Data")
ccle.star.cufflinks <- processData(ccle.star.cufflinks)
ccle.tophat.cufflinks <- processData(ccle.tophat.cufflinks)
ccle.star.stringtie <- processData(ccle.star.stringtie)
ccle.tophat.stringtie <- processData(ccle.tophat.stringtie)

message("Processing GNE Data")
gne.star.cufflinks <- processData(gne.star.cufflinks)
gne.tophat.cufflinks <- processData(gne.tophat.cufflinks)
gne.star.stringtie <- processData(gne.star.stringtie)
gne.tophat.stringtie <- processData(gne.tophat.stringtie)

## Take log2 + 1 transform of TPM for kallisto
ccle.kallisto <- log2(ccle.kallisto + 1)
gne.kallisto <- log2(gne.kallisto + 1)

## df1: frame 1 of gene expression values in TPM
## df2: frame 2 of gene expression values in TPM
## method: "pearson" or "spearman" correlation
## returns named vector of correlation values
getCorrelationMatrix <- function(df1, df2, method) {
  
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
  return(correlation)
}

names <- c("tophat/star", "tophat/kallisto", "star/kallisto", "tophat/tophat", "star/star", "tophat/star/stringtie", "tophat/kallisto/stringtie", "star/kallisto/stringtie")
ccleCorMatrix <- rbind.fill.matrix(list(
  getCorrelationMatrix(ccle.tophat.cufflinks, ccle.star.cufflinks, "spearman"),
  getCorrelationMatrix(ccle.kallisto, ccle.tophat.cufflinks, "spearman"),
  getCorrelationMatrix(ccle.star.cufflinks, ccle.kallisto, "spearman"),
  getCorrelationMatrix(ccle.tophat.cufflinks, ccle.tophat.stringtie, "spearman"),
  getCorrelationMatrix(ccle.star.cufflinks, ccle.star.stringtie, "spearman"),
  getCorrelationMatrix(ccle.tophat.stringtie, ccle.star.stringtie, "spearman"),
  getCorrelationMatrix(ccle.tophat.stringtie, ccle.kallisto, "spearman"),
  getCorrelationMatrix(ccle.star.stringtie, ccle.kallisto, "spearman")))
rownames(ccleCorMatrix) <- names

gneCorMatrix <- rbind.fill.matrix(list(
  getCorrelationMatrix(gne.tophat.cufflinks, gne.star.cufflinks, "spearman"),
  getCorrelationMatrix(gne.kallisto, gne.tophat.cufflinks, "spearman"),
  getCorrelationMatrix(gne.star.cufflinks, gne.kallisto, "spearman"),
  getCorrelationMatrix(gne.tophat.cufflinks, gne.tophat.stringtie, "spearman"),
  getCorrelationMatrix(gne.star.cufflinks, gne.star.stringtie, "spearman"),
  getCorrelationMatrix(gne.tophat.stringtie, gne.star.stringtie, "spearman"),
  getCorrelationMatrix(gne.tophat.stringtie, gne.kallisto, "spearman"),
  getCorrelationMatrix(gne.star.stringtie, gne.kallisto, "spearman")))
rownames(gneCorMatrix) <- names
boxplot(t(gneCorMatrix))


#studyCorMatrix <- rbind.fill.matrix(list(
#  getCorrelationMatrix(ccle.tophat.cufflinks, gne.tophat.cufflinks, "spearman"),
#  getCorrelationMatrix(ccle.star.cufflinks, gne.star.cufflinks, "spearman"),
#  getCorrelationMatrix(ccle.kallisto, gne.kallisto, "spearman"),
#  getCorrelationMatrix(ccle.tophat.stringtie, gne.tophat.stringtie, "spearman"),
# getCorrelationMatrix(ccle.star.stringtie, gne.star.stringtie, "spearman")))
#boxplot(t(studyCorMatrix))
## Kallisto in general gives a worse reproducibility in comparison to STAR/Tophat
## RNAseq quantifies the relative expression of transcripts. 

## df1: vec1, df2: vec2
foldChanges <- function(df1, df2) {
  
  ## Get common rows and genes which have a measured values
  df1 <- df1[!is.na(df1)]
  df2 <- df2[!is.na(df2)]
  commonGenes <- intersect(names(df1), names(df2))
  print(str(list(df1, df2, commonGenes)))
  
  ## Get common genes
  df1 <- df1[commonGenes]
  df2 <- df2[commonGenes]
  return (df1 / df2) 
}
  

