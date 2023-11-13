#!/bin/bash
#PBS -N Spades2
#PBS -j oe
#PBS -l ncpus=12
#PBS -l mem=35gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

source activate spades3.15.5 # have to use this on sequioa because it doesnt have module load spades- this is for a conda env which has spades in it.

# Changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

# Input directory containing paired-end read files
input_dir="$HOME/slu_raw/deinterleaved_slu"
# Output directory for SPAdes results
output_dir="$HOME/slu_raw/deinterleaved_slu/spades_out"

# Iterate over each paired-end read file in the input directory
for forward_reads in "$input_dir"/*_R1_P.trimmed.fastq.gz; do
    
    # Extract the base filename without the extension
    filename=$(basename "$forward_reads")
    sample_name="${filename%_R1_P.trimmed.fastq.gz}"
    
    # Construct the path to the reverse read file
    reverse_reads="${forward_reads%_R1_P.trimmed.fastq.gz}_R2_P.trimmed.fastq.gz"
    
    # Construct the path to the unpaired read file
    forward_unpaired_reads="${forward_reads%_R1_P.trimmed.fastq.gz}_R1_U.trimmed.fastq.gz"
    reverse_unpaired_reads="${reverse_reads%_R2_P.trimmed.fastq.gz}_R2_U.trimmed.fastq.gz"
    
    # Create a directory for the sample within the output directory
    sample_output_dir="$output_dir/$sample_name"
    mkdir -p "$sample_output_dir"
    
    # Run SPAdes for the sample
    spades.py -t 12 --careful --pe1-1 "$forward_reads" --pe1-2 "$reverse_reads" --s1 "$forward_unpaired_reads" --s1 "$reverse_unpaired_reads" -o "$sample_output_dir"
    #I combined the single reads into one library (s1) because of what was written on the spades github
    
    # Change to the output directory and rename outputs
    cd "$sample_output_dir" || exit
    mv contigs.fasta "${sample_name}_spades_contigs.fasta"
    mv scaffolds.fasta "${sample_name}_spades_scaffolds.fasta"
    mv spades.log "${sample_name}_spades_prgm.log"
    mv contigs.paths "${sample_name}_spades_contigs.paths"
    mv scaffolds.paths "${sample_name}_spades_scaffolds.paths"
    mv assembly_graph_with_scaffolds.gfa "${sample_name}_spades_assembly_graph.gfa"
    mv assembly_graph_after_simplification.gfa "${sample_name}_spades_assembly_graph_after_simplification.gfa"
    mv assembly_graph.fastg "${sample_name}_spades_assembly_graph.fastg"
    gzip "$sample_output_dir"/*_spades_*
    
    # Remove the non-assembled trimmed reads to save space
    #rm "$forward_reads" # Removes the original files after trimming to save space
    #rm "$reverse_reads"
    #rm "$forward_unpaired_reads"
    #rm "$reverse_unpaired_reads"
done


### testing for a faster/better assembly without unpaired reads on sample 120 (which gave a bad busco score on the first assembly c:52 F12) ###
##### didn't help!

#!/bin/bash
#PBS -N 120_spadesTEST1
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=31gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

# Changes the current directory to the directory from which the job was submitted.
#cd "${PBS_O_WORKDIR}" || exit
#source activate spades3.15.5

# Run SPAdes for the sample
#spades.py -t 8 --careful --pe1-1 ~/slu_fresh/reads/120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R1_P.trimmed.fastq.gz --pe1-2 ~/slu_fresh/reads/120_FD_12718.1.279562.AGCAAGCA-TGCTTGCT_R2_P.trimmed.fastq.gz -o ~/slu_fresh/spades_tests/120_test