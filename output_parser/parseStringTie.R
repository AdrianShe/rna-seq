## Parse output for stringtie
library(data.table)

parseStringtie <- function(file) {
    lines <- readLines(file)
    ## Get lines with an FPKM value
    lines <- lines[grep("FPKM", lines)]
    annotatedLines <- lines[grep("reference_id", lines)]
    parsedLines <- pblapply(annotatedLines, parseAnnotatedLine)
    finalFrame <- rbindlist(parsedLines)
    return(finalFrame)
}




parseAnnotatedLine <- function(line) {
  tokens <- unlist(strsplit(line, ";"))
  tokens <- strsplit(tokens, "\"")
  getItem <- function(attr) {
    tokens[[grep(attr, tokens)]][2]
  }

  frame <- data.frame(
    "reference_id" = getItem("reference_id"),
    "ref_gene_id" = getItem("ref_gene_id"),
    "ref_gene_name" = getItem("ref_gene_name"),
    "fpkm" = as.numeric(getItem("FPKM")),
    stringsAsFactor = FALSE
    )
  
  return(frame)
}

parseStringtieNoGene <- function(file) {
  lines <- readLines(file)
  ## Get lines with an FPKM value
  lines <- lines[grep("FPKM", lines)]
  annotatedLines <- lines[grep("reference_id", lines)]
  parsedLines <- unlist(pblapply(annotatedLines, parseAnnotatedLineNoGene))
  return(parsedLines)
}

parseAnnotatedLineNoGene <- function(line) {
  tokens <- unlist(strsplit(line, ";"))
  tokens <- strsplit(tokens, "\"")
  getItem <- function(attr) {
    tokens[[grep(attr, tokens)]][2]
  }
  ref <- getItem("reference_id")
  fpkm <- as.numeric(getItem("FPKM"))
  names(fpkm) <- ref
  return(fpkm)
}

#vals <- parseStringtie("Desktop/stringtie_output.gtf")
#print(str(vals))