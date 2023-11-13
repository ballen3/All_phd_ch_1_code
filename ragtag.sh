#!/bin/bash
#PBS -N ragtag_trial_1
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=50gb
#PBS -m abe
#PBS -l walltime=150:00:00
#PBS -M ballen3@go.olemiss.edu

source activate ragtag

cd ~/slu_raw/ragtag_corrected_scaffs || exit
gunzip ~/slu_raw/deinterleaved_slu/scaffolds/120_spades_scaffolds.fasta.gz
gunzip ~/ref_slu/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa.gz
ragtag.py correct ~/ref_slu/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa.gz ~/slu_raw/deinterleaved_slu/scaffolds/120_spades_scaffolds.fasta.gz
gzip ~/ref_slu/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa.gz
gzip ~/slu_raw/deinterleaved_slu/scaffolds/120_spades_scaffolds.fasta.gz
