load("corMatricies_aug28.RData")

methodNames <- c("tophat-cufflinks/star-cufflinks", "tophat-cufflinks/kallisto", "star-cufflinks/kallisto", "tophat-cufflinks/tophat-stringtie", "star-cufflinks/star-stringtie", "tophat-stringtie/star-stringtie", "tophat-stringtie/kallisto", "star-stringtie/kallisto")

studyMethodNames <- c("tophat-cufflinks", "star-cufflinks", "kallisto", "tophat-stringtie", "star-stringtie")

## Take transpose of matrix so correlation is by the method 
studyCorMatrixSpearman <- t(studyCorMatrixSpearman)
studyCorMatrixPearson <- t(studyCorMatrixPearson)
gneCorMatrixSpearman <- t(gneCorMatrixSpearman)
gneCorMatrixPearson <- t(gneCorMatrixPearson)
ccleCorMatrixSpearman <- t(ccleCorMatrixSpearman)
ccleCorMatrixPearson <- t(ccleCorMatrixPearson)

## Take complete cases
studyCorMatrixSpearman <- studyCorMatrixSpearman[complete.cases(studyCorMatrixSpearman),]
studyCorMatrixPearson <- studyCorMatrixPearson[complete.cases(studyCorMatrixPearson),]
gneCorMatrixSpearman <- gneCorMatrixSpearman[complete.cases(gneCorMatrixSpearman),]
gneCorMatrixPearson <- gneCorMatrixPearson[complete.cases(gneCorMatrixPearson),]
ccleCorMatrixSpearman <- ccleCorMatrixSpearman[complete.cases(ccleCorMatrixSpearman),]
ccleCorMatrixPearson <- ccleCorMatrixPearson[complete.cases(ccleCorMatrixPearson),]

## Make boxplots
pdf("correlation_plots.pdf", onefile = TRUE,  width = 25, height = 20)
boxplot(studyCorMatrixSpearman, names = studyMethodNames, xlab = "Method", ylab = "Spearman Correlation", main = paste("Reproducibility between CCLE and GNE on", nrow(studyCorMatrixSpearman), "cell lines"), ylim = c(0,1)) 
boxplot(studyCorMatrixPearson, names = studyMethodNames, xlab = "Method", ylab = "Pearson Correlation", main = paste("Reproducibility between CCLE and GNE on", nrow(studyCorMatrixPearson), "cell lines"), ylim= c(0,1)) 

boxplot(ccleCorMatrixSpearman, names = methodNames, xlab = "Method", ylab = "Spearman Correlation", main = paste("Reproducibility between methods on", nrow(ccleCorMatrixSpearman), "CCLE cell lines"), ylim = c(0,1)) 
boxplot(ccleCorMatrixPearson, names = methodNames, xlab = "Method", ylab = "Pearson Correlation", main = paste("Reproducibility between methods on", nrow(ccleCorMatrixPearson), "CCLE cell lines"), ylim = c(0,1))

boxplot(gneCorMatrixSpearman, names = methodNames, xlab = "Method", ylab = "Spearman Correlation", main = paste("Reproducibility between methods on", nrow(gneCorMatrixSpearman), "GNE cell lines"), ylim = c(0,1)) 
boxplot(gneCorMatrixPearson, names = methodNames, xlab = "Method", ylab = "Pearson Correlation", main = paste("Reproducibility between methods on", nrow(gneCorMatrixPearson), "GNE cell lines"), ylim=c(0,1))

dev.off()
