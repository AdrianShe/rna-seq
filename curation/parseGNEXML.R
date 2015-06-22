library(XML)

## Input: XML file storing sample information and path info
## Output: names vector of cell line information
parseFile <- function(xml, curDirName) {
	parsed <- xmlTreeParse(xml)
	fileName <- parsed$doc$file

	## Get sample names: SAMPLE is 1st child of SAMPLE_SET in XML doc tree
	names <- xmlAttrs(parsed$doc$children$SAMPLE_SET[[1]])

	## Get sample attributes
	## SAMPLE_ATTRIBUTES is 5th child of SAMPLE in XML doc tree
	attr <- xmlToList(parsed$doc$children$SAMPLE_SET[[1]][[5]])
    if (nrow(attr) == 2 && length(attr) == 24) { ## all attributes present
      ## Convert matrix to named vector of tag/value to matrix
     attrMatrix <- matrix(attr, dimnames = NULL, ncol = ncol(attr))
     vec <- unlist(structure(attrMatrix[2,], names = attrMatrix[1,]))
    }
    else {
        vec <- parseRaw(attr)
    }
    vec <- c("filename" = fileName, "dir" = curDirName, names, vec)
    return(vec)
}

## parse and write files
parseAll <- function () {
    setwd("/mnt/work1/users/bhklab/Data/GNE/rna-seq")
    dirs <- list.files() ## Get all directorys of RNA seq data
    
    gneFrame <- data.frame()
    
    ## Only first directory has XML info
    setwd(paste0(dirs[1], "/xmls/samples"))
    res <- sapply(list.files(), function (x) parseFile(x, dirs[1]))
    ## construct data.frame with parsedFiles
    frame <- data.frame(t(res))
    
    ## write final frame
    setwd("/mnt/work1/users/home2/bhcoop4")
    write.csv(frame, file = "gne_rnaseq_metadata.csv")
}

parseRaw <- function(attr) {
    vec <- c()
    names <- c()
    for (i in 1:length(a)) {
        if (is.null(a[[i]][["VALUE"]])) {
             vec[i] <- "NA"
        }
        else {
            vec[i] <- a[[i]][["VALUE"]]
        }
        names[i] <- a[[i]][["TAG"]]
    }
    names(vec) <- names
    return(vec)
}

