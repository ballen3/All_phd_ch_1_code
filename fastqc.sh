#!/bin/bash
#PBS -N fastqc_all2
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

module load fastqc

# changes the current directory to the directory from which the job was submitted.
cd ${PBS_O_WORKDIR}

# Fastqc loop
for i in ~/slu_raw/unassembled/*P.trimmed.fastq.gz;
do fastqc "$i" -o ~/slu_fresh/fastqcOut2/
done

# done after trimming (trimmomatic) and before assembly (spades)
# we want to look at the html files (winscp or similar program to move them onto your local machine)
# HTML output: high GC content in fungal genomes isnt necessarily wrong, it just indicates a lot of repeatable content.

