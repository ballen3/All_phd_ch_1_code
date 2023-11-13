#!/bin/bash
#PBS -N funguild
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

# load python from maple
module load python

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

# Run the script
#python Guilds_v1.1.py -db fungi -otu funguild_taxon_input.txt
python FUNGuild.py taxa -otu funguild_taxon_input.txt -format tsv -classifier sintax
python FUNGuild.py guild -taxa funguild_taxon_input.taxa.txt

python FUNGuild.py taxa -otu /home/ballen3/ch3/funguild_taxon_input.txt -format tsv -classifier sintax

