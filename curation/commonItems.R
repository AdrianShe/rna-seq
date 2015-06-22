
## read curation files
options(stringsAsFactors = FALSE)
cells <- read.csv("cell_annotation_all.csv", na.strings = "")
ccle <- read.csv("ccle_rnaseq_metadata.csv")
gne <- read.csv("gne_rnaseq_metadata.csv")
print(str(cells))
## Obtain cell line names in each curation
ccleNames <- ccle$cells
gneNames <- gne$Cell_line

## Temporary row w/o bad chars and common cases for easy matching
cells[,"unique.id.clean"] <- sapply(cells$unique.cellid, function (x) toupper(gsub("[^a-zA-Z0-9]", "", x)))
cells[,"gne.id.clean"] <- sapply(cells$GNE.cellid, function (x) toupper(gsub("[^a-zA-Z0-9]", "", x)))
cells[,"ccle.id.clean"] <- sapply(cells$CCLE.cellid, function (x) toupper(gsub("[^a-zA-Z0-9]", "", x)))

## For each name in ccleNames, gneNames, obtain row 
message("Processing CCLE")
for (i in 1:length(ccleNames)) {
	
	## Get name of cell line and clean name
	name <- ccleNames[i]
	cleanName <- toupper(gsub("[^a-zA-Z0-9]", "", name))
	
	row <- cells[which(cells$ccle.id.clean == cleanName),] ## Compare clean names
	if (nrow(row) != 0 ){
	cells[which(cells$ccle.id.clean == cleanName), "ccle.rna_seq_name"] <- name ## Assign to row
	}
	
	## Else look at unique id and do the same
	else {
		altRow <- cells[which(cells$unique.id.clean == cleanName),]
		if (nrow(altRow) == 0) {
			print(paste(name, "not found- creating new row"))
			cells[nrow(cells) + 1, "ccle.rna_seq_name"] <- name
		}
		 cells[which(cells$unique.id.clean == cleanName), "ccle.rna_seq_name"] <- name
	}
}

## For each name in ccleNames, gneNames, obtain row 
message("Processing GNE")
for (i in 1:length(gneNames)) {
	
	## Get name of cell line and clean name
	name <- gneNames[i]
	cleanName <- toupper(gsub("[^a-zA-Z0-9]", "", name))
	
	row <- cells[which(cells$gne.id.clean == cleanName),] ## Compare clean names
	if (nrow(row) != 0 ){
	cells[which(cells$gne.id.clean == cleanName), "gne.rna_seq_name"] <- name ## Assign to row
	}
	
	## Else look at unique id and do the same
	else {
		altRow <- cells[which(cells$unique.id.clean == cleanName),]
		if (nrow(altRow) == 0) {
			print(paste(name, "not found- creating new row"))
			cells[nrow(cells) + 1,  "gne.rna_seq_name"] <- name
		}
		 cells[which(cells$unique.id.clean == cleanName),  "gne.rna_seq_name"] <- name
	}
}

## Remove temporary rows
temp <- c("unique.id.clean", "ccle.id.clean", "gne.id.clean")
cells <- cells[,!(names(cells) %in% temp)]
write.csv(cells, file = "cell_annotation_all_rnaseq.csv")

## Find common ids
common <- cells[!(is.na(cells$ccle.rna_seq_name) | is.na(cells$gne.rna_seq_name)),]
write.csv(common, file = "CCLE_GNE_common_profiles.csv")
