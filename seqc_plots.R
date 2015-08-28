ccle <- read.csv("CCLE_RNA_SeqC_res.csv")
pdf("CCLE_SeqC_plots.pdf", onefile = TRUE)
boxplot(ccle$Total.Purity.Filtered.Reads.Sequenced / 1000000, main = "Distribution of Number of Reads in CCLE RNA-Seq", ylab = "Number of Reads (Millions)", xlab = "CCLE")
boxplot(ccle$Mapping.Rate, ccle$Mapped.Unique.Rate.of.Total, ccle$Unique.Rate.of.Mapped, main = "Mapping rates of reads in CCLE RNA-Seq", ylab = "Proportion", xlab = "Mapping Rate", names = c("Mapped Reads/All Reads", "Unique Mapped Reads/All Reads", "Unique Mapped Reads/Mapped Reads"),
	ylim = c(0,1))
plot(ccle$Mapped / 1000000, ccle$Genes.Detected / 1000, xlab = "Number of Mapped Reads (Millions)", ylab = "Genes Detected (Thousands)", main = "Number of Genes Detected v. Number of Mapped Reads")
plot(ccle$Mapped / 1000000, ccle$Transcripts.Detected / 1000, xlab = "Number of Mapped Reads (Millions)", ylab = "Transcripts Detected (Thousands)", main = "Number of Transcripts Detected v. Number of Mapped Reads")
dev.off()