#!/bin/bash
#PBS -N antismash
#PBS -j oe
#PBS -l ncpus=40
#PBS -l mem=50gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

source activate antismash
source activate augustus

#set input files
assemblies="/ddn/home12/r2620/slu_fresh/assemblies/high_buscos" #does include the missing 17 that worked and were good enough
annotations="/ddn/home12/r2620/slu_fresh/antismash/aug_annos"
#set output dir
antismash_out="/ddn/home12/r2620/slu_fresh/antismash/as_output"

# Get gff (gene annotation) files using augustus
#for file in ${assemblies}/*.fasta.gz
#do
#filename=$(basename "$file")
#sample_name="${filename%.*}"
#gunzip -c "$file" > "${assemblies}/${sample_name}"
#augustus [parameters] --species=laccaria_bicolor "${assemblies}/${sample_name}" > "${annotations}"/"${sample_name}".gff
#gzip "${assemblies}/${sample_name}"
#echo "Augustus done for ${filename}"
#done

#Run antismash for fungi
for i in "${assemblies}"/*.fasta.gz
do
    # extract the basename of i, excluding the "_spades_scaffolds.fasta.gz" ending
    sample_name=$(basename ${i} "_spades_scaffolds.fasta.gz")
    
    # Create the output directory if it doesn't exist
    mkdir -p "$antismash_out"/"${sample_name}"
    
    # Run antismash
    echo "********** Antismash started for ${sample_name} **********"
    antismash "$i" \
    --taxon fungi \
    --output-dir "$antismash_out"/"${sample_name}" \
    --output-basename "${sample_name}" \
    --cb-general --cb-knownclusters --cb-subclusters \
    --asf --pfam2go --clusterhmmer --cassis --cc-mibig --tfbs \
    --genefinding-gff3 "$annotations"/"${sample_name}"_spades_scaffolds.fasta.gff
    echo "********** Antismash done for ${sample_name} **********"
done

# Files needed from antismash output for BigSCAPE:
#The region_table.csv file: This file provides information about each identified BGC, including the cluster ID, start and end coordinates, and the predicted gene products within the cluster.
#The final_clusters.txt file: This file contains a list of the BGCs identified by AntiSMASH that will be used as input for BigSCAPE.