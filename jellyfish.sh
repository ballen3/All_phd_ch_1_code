#!/bin/bash
#PBS -N jellyfishKMER_120_test.1
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=35gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

source activate jellyfish

jellyfish count -m 31 -C 120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R1_P.trimmed.fastq.gz -C 120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R2_P.trimmed.fastq.gz
