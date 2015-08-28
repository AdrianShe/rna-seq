library(testthat)
## pos: string of form <chromosome num>:<start>-<end>
getGeneChromosome <- function(pos) {
	colonLoc <- regexpr(":", pos)
	chromosome <- substr(pos, 1, colonLoc - 1)
	return(chromosome)	
}

## Unit tests
test_that("getGeneChromosome works properly", {
	expect_equal(getGeneChromosome("1:169631244-169863408"), "1")
	expect_equal(getGeneChromosome("13:77564794-77601330"), "13")
	expect_equal(getGeneChromosome("X:64732461-64754655"), "X")	
})


## pos: string of form <chromosome num>:<start>-<end>
getGeneLength <- function(pos) {
	colonLoc <- regexpr(":", pos)
	hyphenLoc <- regexpr("-", pos)
	start <- substr(pos, colonLoc + 1, hyphenLoc - 1)
	end <- substr(pos, hyphenLoc + 1, nchar(pos))
	return(as.numeric(end) - as.numeric(start))
}

## Unit tests
test_that("getGeneLength works properly", {
	expect_equal(getGeneLength("X:99883666-99894988"), 11322)
	expect_equal(getGeneLength("20:49505584-49575092"), 69508)
	expect_equal(getGeneLength("1:169631244-169863408"), 232164)	
})

