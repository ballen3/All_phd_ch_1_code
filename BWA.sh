#!/bin/bash
#PBS -N BWA_all.test4
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

# Change the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

# Activate required modules and conda environment
module load bwa
module load python
source activate samtools

# Define the path to the reference genome and the output directory
reference_genome="$HOME/slu_fresh/bwa_mapping/index_ref/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa"
output_dir="$HOME/slu_fresh/bwa_mapping/aligned_reads"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

# Loop through the R1_P files and perform BWA alignment
for R1_P in ~/slu_fresh/reads/*R1_P*
do
    # Extract the sample name from the R1_P file name
    sample_name=$(basename "$R1_P" "_R1_P.trimmed.fastq.gz")
    
    # Construct the path to the corresponding R2_P file
    R2_P="$HOME/slu_fresh/reads/${sample_name}_R2_P.trimmed.fastq.gz"
    
    # Run BWA alignment and sort the output BAM file
    bwa mem -t 8 "${reference_genome}" "${R1_P}" "${R2_P}" | samtools sort -o "${output_dir}/${sample_name}_bwa_output.sorted.bam"
    
    echo "Generated alignment: ${sample_name}"
done