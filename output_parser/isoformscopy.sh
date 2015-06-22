#! /bin/bash
module load R

cd /mnt/work1/users/bhklab/users/adrian/tophat_runs

mkdir /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_ccle
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_ccle/$d
        dir="/mnt/work1/users/bhklab/users/adrian/tophat_runs/$d"
	dirName="CCLE/isoforms.fpkm_tracking"	
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_ccle/$d
done


mkdir /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_gne
for d in */; do
    mkdir /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_gne/$d
    dir="/mnt/work1/users/bhklab/users/adrian/tophat_runs/$d"
    dirName="GNE/isoforms.fpkm_tracking"
    cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_gne/$d
done

cd /mnt/work1/users/bhklab/users/adrian/star_runs

mkdir /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_ccle
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_ccle/$d
	dir="/mnt/work1/users/bhklab/users/adrian/star_runs/$d"
	dirName="CCLE/isoforms.fpkm_tracking"
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_ccle/$d
done


mkdir /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_gne
for d in */; do
	mkdir /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_gne/$d
	dir="/mnt/work1/users/bhklab/users/adrian/star_runs/$d"
	dirName="GNE/isoforms.fpkm_tracking"
	cp $dir$dirName  /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_gne/$d
done

cd ..
Rscript /mnt/work1/users/bhklab/users/adrian/isoformsFPKM.R /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_ccle /mnt/work1/users/bhklab/users/adrian/res/tophat_isoforms_res_ccle.csv
Rscript /mnt/work1/users/bhklab/users/adrian/isoformsFPKM.R /mnt/work1/users/bhklab/users/adrian/isoforms.fpkm_tracking_gne /mnt/work1/users/bhklab/users/adrian/res/tophat_isoforms_res_gne.csv
Rscript /mnt/work1/users/bhklab/users/adrian/isoformsFPKM.R /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_ccle /mnt/work1/users/bhklab/users/adrian/res/star_isoforms_res_ccle.csv
Rscript /mnt/work1/users/bhklab/users/adrian/isoformsFPKM.R /mnt/work1/users/bhklab/users/adrian/star.isoforms.fpkm_tracking_gne /mnt/work1/users/bhklab/users/adrian/res/star_isoforms_res_gne.csv

rm -rf isoforms.fpkm_tracking_ccle
rm -rf isoforms.fpkm_tracking_gne
rm -rf star.isoforms.fpkm_tracking_ccle
rm -rf star.isoforms.fpkm_tracking_gne
