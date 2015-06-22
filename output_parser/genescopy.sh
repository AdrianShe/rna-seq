#! /bin/bash
module load R

cd /mnt/work1/users/bhklab/users/adrian/tophat_runs

mkdir /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_ccle
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_ccle/$d
        dir="/mnt/work1/users/bhklab/users/adrian/tophat_runs/$d"
	dirName="CCLE/genes.fpkm_tracking"	
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_ccle/$d
done


mkdir /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_gne
for d in */; do
    mkdir /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_gne/$d
    dir="/mnt/work1/users/bhklab/users/adrian/tophat_runs/$d"
    dirName="GNE/genes.fpkm_tracking"
    cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_gne/$d
done

cd /mnt/work1/users/bhklab/users/adrian/star_runs

mkdir /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_ccle
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_ccle/$d
	dir="/mnt/work1/users/bhklab/users/adrian/star_runs/$d"
	dirName="CCLE/genes.fpkm_tracking"
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_ccle/$d
done


mkdir /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_gne
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_gne/$d
	dir="/mnt/work1/users/bhklab/users/adrian/star_runs/$d"
	dirName="GNE/genes.fpkm_tracking"
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_gne/$d
done

cd ..
Rscript /mnt/work1/users/bhklab/users/adrian/genesFPKM.R /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_ccle /mnt/work1/users/bhklab/users/adrian/res/tophat_genes_res_ccle.csv
Rscript /mnt/work1/users/bhklab/users/adrian/genesFPKM.R /mnt/work1/users/bhklab/users/adrian/genes.fpkm_tracking_gne /mnt/work1/users/bhklab/users/adrian/res/tophat_genes_res_gne.csv
Rscript /mnt/work1/users/bhklab/users/adrian/genesFPKM.R /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_ccle /mnt/work1/users/bhklab/users/adrian/res/star_genes_res_ccle.csv
Rscript /mnt/work1/users/bhklab/users/adrian/genesFPKM.R /mnt/work1/users/bhklab/users/adrian/star.genes.fpkm_tracking_gne /mnt/work1/users/bhklab/users/adrian/res/star_genes_res_gne.csv

rm -rf genes.fpkm_tracking_ccle
rm -rf genes.fpkm_tracking_gne
rm -rf star.genes.fpkm_tracking_ccle
rm -rf star.genes.fpkm_tracking_gne
