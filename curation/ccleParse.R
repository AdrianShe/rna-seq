library(XML)

## x: name of XML file
## dirNum: number of the directory
parseDoc <- function(x, dirNum) {
	
	## Obtain document tree
	doc <- xmlTreeParse(x)
	
	## Obtain root of xml tree
	top <- xmlRoot(doc)
		
	## Parse results for each result
	frames <- lapply(2:(length(top) - 1), function (x) {
		val <- xmlToList(top[[x]])
		files <- unlist(val$files) ## files needs extra parsing because it is a sub XML node
		impInfo <- data.frame(	"dir" = dirNum,
		"analysis_id" = val$analysis_id,
		"file_name" = files[1],
		"size" = files[2],
		"analysis_data_uri"= val$analysis_data_uri) ## construct frame from important information
	})
	res <- do.call("rbind", frames)
	return(res)
	
}

## Assume in dir where all manifest files present
files <- c("manifest.xml", "manifest-48CL.xml", "manifest-703CL.xml", "manifest-155extra.xml")

## parse each file and add to frame
frame <- data.frame()
for (i in 1:length(files)) {
	curDoc <- parseDoc(files[i], i)
	frame <- rbind(frame, curDoc)
}

## Create column cells with cell line name for each file
cells <- sapply(as.vector(t(frame["file_name"])), function (x) {
		str <- sub("\\.[0-9]\\.bam", "", x) ## remove end of file name
		str <- sub("\\w*\\.", "", str) ## remove front of filename
	 })

## Construct and write final frame
frame <- data.frame(frame, "cells" = cells)
write.csv(frame, file = "ccle_rnaseq_curation.csv")