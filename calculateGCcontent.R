calculateGCcontent <- function(dna) {
	total <- nchar(dna)
	noGC <- nchar(gsub("G|C", "", dna))
	return((total - noGC) / total)
}

library(RCurl)
getAllGCs <- function(annotation) {
	values <- as.character(annotation$diff.est_id)
	gcs <- pbapply::pbsapply(values, function (x) {
		sequence <- getURL(paste0("http://rest.ensembl.org/sequence/id/", x, "?content-type=text/plain"))
		return(calculateGCcontent(sequence))
	})
	return(gcs)
}