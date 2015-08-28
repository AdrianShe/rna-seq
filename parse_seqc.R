## Script to parse and visualize RNA Seq C results

library(XML)

## command line utility with the argument being the file to parse
args <- commandArgs(trailing = TRUE)
html <- args[1]
filename <- args[2]
print(paste("Parsing", html))

## Parse tables
message("Reading tables from HTML file")
tables <- readHTMLTable(html, as.data.frame=FALSE)

## Convert columns with numbers to numeric
convertColsToNumeric <- function(table) {
	table <- data.frame(table, stringsAsFactors = FALSE)
	numeric <- table[,!(colnames(table) %in% c("Sample", "Note"))]
	numeric <- apply(numeric, 2, function (x) as.numeric(gsub(",", "", x)))
	newTable <- data.frame(table[,c("Sample", "Note")], numeric)
	return(newTable)
}

seqc_df <- lapply(tables, convertColsToNumeric)
seqc_df[2:5] <- lapply(seqc_df[2:5], function (x) x[,!colnames(x) %in% c("Sample", "Note")])
seqc_frame <- do.call("cbind", seqc_df)
colnames(seqc_frame) <- gsub("NULL.", "", colnames(seqc_frame))
write.csv(seqc_frame, filename)
message("DONE!")
