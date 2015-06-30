ccle.star.cufflinks <- get(load("~/Desktop/rna_seq_results/star_isoforms_res_ccle.RData"))
gne.star.cufflinks <- get(load("~/Desktop/rna_seq_results/star_isoforms_res_gne.RData"))

ccle.tophat.cufflinks <- get(load("~/Desktop/rna_seq_results/tophat_isoforms_res_ccle.RData"))
gne.tophat.cufflinks <- get(load("~/Desktop/rna_seq_results/tophat_isoforms_res_gne.RData"))

ccle.kallisto <- get(load("~/Desktop/rna_seq_results/ccle_kallisto.RData"))
gne.kallisto <- get(load("~/Desktop/rna_seq_results/gne_kallisto.RData"))

ccle.tophat.stringtie <- get(load("~/Desktop/rna_seq_results/ccle_tophat_stringtie.RData"))
gne.tophat.stringtie <- get(load("~/Desktop/rna_seq_results/gne_tophat_stringtie.RData"))

ccle.star.stringtie <- get(load("~/Desktop/rna_seq_results/ccle_star_stringtie.RData"))
gne.star.stringtie <- get(load("~/Desktop/rna_seq_results/gne_star_stringtie.RData"))

rm(gne_tophat_stringtie, gne_star_stringtie, ccle_star_stringtie, gne_star_stringtie)
save.image(file = "isoforms.RData")
rm(list=ls())