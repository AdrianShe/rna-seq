## Script to Parse Memory Log Files in R
 
## Convert a string of the form "%H:%M:%S" into seconds
convertToSeconds <- function(time) {
 tokens <- strsplit(time, ":")
 tokens <- unlist(tokens)
 tokens <- as.numeric(tokens)
 return(tokens[1] * 3600 + tokens[2] * 60 + tokens[3]) 
}

## Convert a string of the form "..G" or "..M" into a numeric
## number of gigabytes
convertToGB <- function(x) {
  if (length(grep("G", x)) == 1) { 
	x <- gsub("G", "", x)
	return(as.numeric(x)) 
	}
  else {
	 x <- gsub("M", "", x)
	 return(as.numeric(x) / 1024)
	 }
}

## Parses log file with memory information
getFrame <- function(filename) {
	readFrame <- read.table(filename, col.names = c("usage", "num", "cpu", "mem", "unit", 	"io", "vmem", "maxvmem"), stringsAsFactors = FALSE)
	impVals <- readFrame[,c(-1,-2,-5)]
	
	## Remove commas 
	impVals <- data.frame(apply(impVals, 2, gsub, pattern=",", replacement=""))
		
	## Parse CPU column
	impVals$cpu <- gsub("cpu=", "", impVals$cpu)
	impVals$cpu <- sapply(impVals$cpu, convertToSeconds)
	
	## Parse mem and io columns
	impVals$mem <- as.numeric(gsub("mem=", "", impVals$mem))
	impVals$io <- as.numeric(gsub("io=", "", impVals$io))

	## Parse vmem and maxvmem columns
	impVals$vmem <- gsub("vmem=", "", impVals$vmem)
	impVals$maxvmem <-gsub("maxvmem=", "", impVals$maxvmem)
	impVals$vmem <- sapply(impVals$vmem, convertToGB)
	impVals$maxvmem <- sapply(impVals$maxvmem, convertToGB)
	
	return(impVals)
}

getMemoryPlot <- function(df) {
	lim <- max(df[,5], na.rm = TRUE)
	plot(df[,1], df[,5], col = "blue", xlab = "CPU Time (s)", ylab = "Memory Used (GB)", main = "Memory Used During StringTie Pipeline", type = "l", ylim = c(0, lim))
	par(new = T)
	plot(df[,1], df[,4], col = "red", xlab = "CPU Time (s)", ylab = "Memory Used (GB)", main = "Memory Used During StringTie Pipeline", type = "l", ylim = c(0, lim))
	legend("topleft", c("Memory Limit", "Memory Used", "IO Usage"), lty = c(1,1,1), col = c("blue", "red", "green"))
}
