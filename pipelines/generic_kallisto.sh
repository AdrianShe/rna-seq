#!/bin/bash
#$ -S /bin/bash
#$ -N generic_kallisto
#$ -o /mnt/work1/users/home2/bhcoop4/run/logs
#$ -e /mnt/work1/users/home2/bhcoop4/run/logs

module load kallisto 

## Command line arguments: $1 study, $2 cell line name $3 location of fastqs
cd /mnt/work1/users/bhklab/users/adrian/kallisto_runs
mkdir $2
cd $2
mkdir $1
cd $1
kallisto quant -i /mnt/work1/users/bhklab/users/adrian/kallisto_index.idx -o . $3 $4