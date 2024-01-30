#!/bin/bash
#PBS -N genome.size
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=50gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu
# Specify the directory containing the compressed FASTA files
fasta_dir="/ddn/home12/r2620/slu_fresh/assemblies/high_buscos"

# Specify the output directory and TSV file
output_dir="/ddn/home12/r2620/slu_fresh/basic_stats/genome_size"
output_tsv="$output_dir/all_genome_sizes.tsv"

# Create the header for the output TSV file
echo -e "File\tEstimated_Genome_Size_bp" > "$output_tsv"

# Iterate through all .fasta.gz files in the directory
for fasta_file in "$fasta_dir"/*.fasta.gz; do
    # Extract the basename of the file (without the extension)
    base_name=$(basename "$fasta_file" "_spades_scaffolds.fasta.gz")

    # Use zcat to read the compressed file, grep to extract sequence lines, and awk to calculate their lengths
    total_size=$(zcat "$fasta_file" | grep -v ">" | awk '{ total += length($0) } END { print total }')

    # Append the result to the output TSV file
    echo -e "$base_name\t$total_size" >> "$output_tsv"

    # Print a message
    echo "Estimated genome size for $base_name added to $output_tsv"
done

# Print a final message
echo "All estimated genome sizes written to $output_tsv"
