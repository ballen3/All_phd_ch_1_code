#!/bin/bash
#PBS -N purge
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

# Source directory containing the files you want to move
source_dir="$HOME/slu_raw/deinterleaved_slu"
# Destination directory where you want to move the files
destination_dir="$HOME/slu_raw/deinterleaved_slu/redo_spades"
# Read the list of wildcard names from wildcard_list.txt
while IFS= read -r wildcard; do
    # Use find to locate files matching the wildcard in the source directory
    find "$source_dir" -name "$wildcard" -exec mv {} "$destination_dir" \;
done < "$HOME/slu_raw/deinterleaved_slu/output_spades/broken_spades.out"