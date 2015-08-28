## Correlation by tissue types

load("~/Desktop/res/kallistoMatricies.RData")
ccleMatrix <- log2(ccleMatrix + 1)
gneMatrix <- log2(gneMatrix + 1)
rownames(ccleMatrix) <- as.vector(rownames(ccleMatrix))
rownames(gneMatrix) <- as.vector(rownames(gneMatrix))

curation <- read.csv("~/Desktop/rna_seq_curation/CCLE_GNE_common_profiles.csv")
curation$unique.cellid <-sapply(curation$unique.cellid , function (x) gsub(" |/", "-", x))
curation$unique.cellid <-sapply(curation$unique.cellid , function (x) gsub(",", " ", x))
curation$unique.cellid <-sapply(curation$unique.cellid , function (x) gsub(" -", "-", x))
cells <- tapply(curation$unique.cellid, list(curation$unique.tissueid), identity)

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

pcor <- lapply(cells, function (x) getCorrelationMatrix(ccleMatrix[x,], gneMatrix[x,], "pearson"))
scor <- lapply(cells, function (x) getCorrelationMatrix(ccleMatrix[x,], gneMatrix[x,], "spearman"))

