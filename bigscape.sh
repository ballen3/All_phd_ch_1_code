#!/bin/bash
#PBS -N bigscape.1
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=50gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

source activate bigscape

#Input/output paths
antismash_out="/ddn/home12/r2620/slu_fresh/antismash/as_output/"
bs_out="/ddn/home12/r2620/slu_fresh/bigscape/output" 

#Run BigScape analysis on .gbk files from antismash
/ddn/home12/r2620/BiG-SCAPE-1.1.5/bigscape.py -i "${antismash_out}" -o "${bs_out}"

