## load R objects

## Get common cell lines between all
kallistoCCLE <- ccleMatrix
kallistoGNE <- gneMatrix
starCCLE <- readFiles[[3]][rownames(kallistoCCLE),]
starGNE <- readFiles[[4]][rownames(kallistoGNE),]
tophatCCLE <- readFiles[[7]][rownames(kallistoCCLE),]
tophatGNE <- readFiles[[8]][rownames(kallistoGNE),]

studyCorrelations <-
data.frame(
	getAllCorrelations(tophatCCLE, tophatGNE, "pearson"),
	getAllCorrelations(tophatCCLE, tophatGNE, "spearman"),
	getAllCorrelations(starCCLE, starGNE, "pearson"),
	getAllCorrelations(starCCLE, starGNE, "spearman"),
	getAllCorrelations(kallistoCCLE, kallistoGNE, "pearson"),
	getAllCorrelations(kallistoCCLE, kallistoGNE,  "spearman"),
)

getAllCorrelations <- function(x, y, m) {
	if (nrow(x) != nrow(y)) {
		stop("Frames do not have the number of same rows")
	}
	if (ncol(x) != ncol(y)) {
		stop("Frames do not have the number of same columns.")
	}
	sapply(1:nrow(x), function (i) cor(x[i,], y[i,], use = "complete", method = m))
}