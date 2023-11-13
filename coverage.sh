#!/bin/bash
#PBS -N coverage_calc
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

souce activate samtools

# changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR} || exit" || exit

# Set the input directory and output file name
input_dir="$HOME/slu_fresh/bwa_mapping/aligned_reads"
output_file=depth.txt

# Iterate through the BAM files in the input directory
for bam_file in ${input_dir}/*.bam
do
    # Extract the sample name from the file name
    sample_name=$(basename ${bam_file}.bam)
    
    # Total genome size can be calculated like this:
    genome_size=(samtools view -H bam_file | grep -P '^@SQ' | cut -f 3 -d ':' | awk '{sum+=$1} END {print sum}')
    
    # average X coverage (divide by the total size of your genome from above)
    samtools depth  bamfile  |  awk '{sum+=$3} END { print "Average = ",sum/${genome_size}' | > ${sample_name}.depth
    
    # Append the results to the output file
    cat ${sample_name}.depth >> ${output_file}
    
    # Delete the temporary depth file
    rm ${sample_name}.depth
done

# The base commands (not in a loop)
#samtools view -H bam_file | grep -P '^@SQ' | cut -f 3 -d ':' | awk '{sum+=$1} END {print sum}'
#samtools depth  bamfile  |  awk '{sum+=$3} END { print "Average = ",sum/NR}'

