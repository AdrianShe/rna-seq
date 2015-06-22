#!/bin/bash
#$ -S /bin/bash
#$ -N star_generic
#$ -o /mnt/work1/users/home2/bhcoop4/run/logs
#$ -e /mnt/work1/users/home2/bhcoop4/run/logs
module load igenome-human/GRCh37
module load cufflinks
module load STAR
module load samtools
module load stringtie

## Usage
## CCLE: $1: study, $2 name of cell line, $3 fastq1, $4 fastq2
## GNE: $1: study, $2 name of cell line, $3 inputdir_1 $4 inputdir_2

## Navigate to file
cd  /mnt/work1/users/bhklab/users/adrian/star_runs
mkdir $2
cd $2
mkdir $1
cd $1

if [ "$1" == "GNE" ]; then
    echo "Running STAR"
    STAR --genomeDir /mnt/work1/users/bhklab/users/adrian/GRCh37_STAR_v12  --runThreadN 12 --outSAMstrandField intronMotif --readFilesIn $3 $4 --readFilesCommand zcat
fi

if [ "$1" == "CCLE" ]; then
	echo "Running STAR"
    STAR --genomeDir /mnt/work1/users/bhklab/users/adrian/GRCh37_STAR_v12  --runThreadN 12 --outSAMstrandField intronMotif --readFilesIn $3 $4
fi

echo "Converting to bam file"
samtools view -bS Aligned.out.sam > Aligned.out.bam

echo "Sorting bam file"
samtools sort Aligned.out.bam Aligned.out.sorted

echo "Running cufflinks"
cufflinks --no-update-check -N -p 8 -G $GTF -o . Aligned.out.sorted.bam

echo "Running stringtie"

samtools view -h Aligned.out.sorted.bam | perl -ne 'if(/HI:i:(\d+)/) { $m=$1-1; $_ =~ s/HI:i:(\d+)/HI:i:$m/} print $_;' > Aligned.out.sorted.stringtie.bam

stringtie Aligned.out.sorted.stringtie.bam -v -o stringtie_output.gtf -p 8 -G $GTF



