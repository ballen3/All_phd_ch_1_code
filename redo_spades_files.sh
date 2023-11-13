#!/bin/bash
#PBS -N redo_spades_files
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

# Set the source and output directories
source_dir=~/slu_raw/deinterleaved_slu/redo_spades
output_dir=./pruned_dupes

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Associative arrays to store the largest number_after_fd for each unique_number
declare -A largest_numbers

# Loop through the files in the source directory
for file in "$source_dir"/*; do
    # Check if the file is a valid fastq.gz file and ends with _R1_P.trimmed.fastq.gz
    if [[ "$file" == *"_R1_P.trimmed.fastq.gz" ]]; then
        # Extract the unique number before "_FD_"
        unique_number=$(echo "$file" | grep -oP "^\d+(?=_FD_)")
        
        # Extract the characters after "_FD_" up to the letter before "_R"
        number_after_fd=$(echo "$file" | awk -F '_FD_|_R' '{print $2}' | sed 's/\.[A-Z]\+-[A-Z]\+//')
        
        # Remove non-numeric characters from the number_after_fd
        number_after_fd_numeric=$(echo "$number_after_fd" | tr -dc '0-9')
        
        # the letter protion
        letter_portion=$(echo "$file" | grep -oP "(?<=\.)[A-Z]+-[A-Z]+(?=_R)")
        
        # Check if the unique_number is not present in the largest_numbers array
        if [[ -z "${largest_numbers[$unique_number]}" ]]; then
            largest_numbers["$unique_number"]=$number_after_fd_numeric
            elif (( number_after_fd_numeric > largest_numbers[$unique_number] )); then
            largest_numbers["$unique_number"]=$number_after_fd_numeric
        fi
    fi
done

# Loop through the largest_numbers array and move the files to the output directory
for unique_number in "${!largest_numbers[@]}"; do
    mv "$source_dir/${unique_number}_FD_${largest_numbers[$unique_number]}${letter_portion}_R1_P.trimmed.fastq.gz" "$output_dir"
    mv "$source_dir/${unique_number}_FD_${largest_numbers[$unique_number]}${letter_portion}_R1_U.trimmed.fastq.gz" "$output_dir"
    mv "$source_dir/${unique_number}_FD_${largest_numbers[$unique_number]}${letter_portion}_R2_P.trimmed.fastq.gz" "$output_dir"
    mv "$source_dir/${unique_number}_FD_${largest_numbers[$unique_number]}${letter_portion}_R2_U.trimmed.fastq.gz" "$output_dir"
done






file="253_FD_52591.3.391316.CTGTTAGG-CTGTTAGG_R1_U.trimmed.fastq.gz"
letter_portion=$(echo "$file" | grep -oP "(?<=\.)[A-Z]+-[A-Z]+(?=_R)")
number_before_fd=$(echo "$file" | grep -oP "^\d+(?=_FD_)")
number_between_fd_last_dot=$(echo "$file" | awk -F '_FD_|_R' '{print $2}' | sed 's/\.[A-Z]\+-[A-Z]\+//')


echo "Letter Portion: $letter_portion"
echo "Number before _FD_: $number_before_fd"
echo "Number between _FD_ and last dot: $number_between_fd_last_dot"

