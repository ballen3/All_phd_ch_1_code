#!/bin/bash
#PBS -N redundans_assembly.1
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=50gb
#PBS -m abe
#PBS -l walltime=150:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

source activate redundans

redundans.py -v -i ~/slu_fresh/reads/120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R1_P.trimmed.fastq.gz ~/slu_fresh/reads/120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R2_P.trimmed.fastq.gz\
-f ~/slu_fresh/spades_tests/120_test/120_contigs.fasta -o ~/slu_fresh/redundans_assembly_tests/120_test