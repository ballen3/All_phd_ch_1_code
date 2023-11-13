#!/bin/bash
#PBS -N abyss_120_test.1
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=35gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

source activate abyss-env

# changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

# Directory containing the paired-end read files
input_dir="$HOME/practice_code"

# Iterate over the paired-end read files in the input directory
for read_file in "$input_dir"/*_R1_P.trimmed.fastq.gz; do
    # Extract the sample name from the read file name
    sample=$(basename "$read_file" _R1_P.trimmed.fastq.gz)
    
    # Construct the paths to the paired-end read files
    read1="$input_dir/$sample"_R1_P.trimmed.fastq.gz
    read2="$input_dir/$sample"_R2_P.trimmed.fastq.gz
    
    # Create a unique output directory for each sample
    #output_dir="output_$sample"
    
    # Run ABySS assembly for the current sample
    abyss-pe name="$sample" k=64 B=50G in="$read1 $read2"
done


abyss-pe name=120 k=96 B=2G in='reads1.fa reads2.fa'