#!/bin/bash
#$ -S /bin/bash
#$ -N tophat_stringtie_cufflinks_generic
#$ -o /mnt/work1/users/home2/bhcoop4/run/logs
#$ -e /mnt/work1/users/home2/bhcoop4/run/logs
module load igenome-human/GRCh37
module load tophat2
module load bowtie
module load stringtie
module load cufflinks

## Usage:
## generic_tophat_stringtie
## $1: CCLE $2: name of cell line  $3 name of fastq $4 name offastq $5 name of bam
## $1: GNE $2: name of cell line $3 name of fastq $4 name of fastq 
cd /mnt/work1/users/bhklab/users/adrian/tophat_runs
mkdir $2
cd $2
mkdir $1
cd $1

if (! [ -a accepted_hits.bam ]) && [ "$1" == "CCLE" ]; then
    echo "Running picard"
	module load picard
	java -Xmx16g -jar $picard_dir/SamToFastq.jar  I=$5 F=$3 F2=$4
fi 

if ! [  -a accepted_hits.bam ]; then
    echo "Running tophat"
	tophat2 --library-type fr-firststrand --no-coverage-search --keep-fasta-order -p 8 -G $GTF  -o . $BOWTIE2INDEX $3 $4
fi

echo "Running cufflinks"
cufflinks --no-update-check -N -p 8 -G $GTF -o . accepted_hits.bam

mkdir ./stringtie_output
echo "Running stringtie"
stringtie accepted_hits.bam -v -o ./stringtie_output -p 8 -G $GTF

