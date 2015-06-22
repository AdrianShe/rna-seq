#!/bin/bash
#$ -S /bin/bash
#$ -N calibrate_genome

STAR  --runMode genomeGenerate --runThreadN 12 --genomeDir /mnt/work1/users/bhklab/users/adrian/GRCh37_STAR_v12 --genomeFastaFiles $REF --sjdbGTFfile /$GTF --sjdbOverhang 75




