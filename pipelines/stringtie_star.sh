#!/bin/bash
#$ -S /bin/bash
#$ -N stringtie_from_star_output_generic
#$ -o /mnt/work1/users/home2/bhcoop4/run/logs
#$ -e /mnt/work1/users/home2/bhcoop4/run/logs
module load igenome-human/GRCh37
module load stringtie

## Usage
## CCLE: $1: study, $2 name of cell line, $3 fastq1, $4 fastq2
## GNE: $1: study, $2 name of cell line, $3 inputdir_1 $4 inputdir_2

## Navigate to file
#cd  /mnt/work1/users/bhklab/users/adrian/star_runs
#cd $2
#cd $1
cd $1
echo "Running stringtie"

samtools view -h Aligned.out.sorted.bam | perl -ne 'if(/HI:i:(\d+)/) { $m=$1-1; $_ =~ s/HI:i:(\d+)/HI:i:$m/} print $_;'> Aligned.out.sorted.stringtie.bam

stringtie Aligned.out.sorted.stringtie.bam -v -o stringtie_output.gtf -p 8 -G $GTF



