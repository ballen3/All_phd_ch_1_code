#!/bin/bash
#PBS -N smudgeplot_1
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

#activate the conda env with busco
source activate smudgeplot

#1. Calculate kmer pairs
## Let's count kmers using kmc. This time we are not that sure what we are dealing with, so we want to extract a histogram of kmers as well to determine L and U:
ls *.fastq.gz > FILES
kmc -k21 -m64 -ci1 -cs10000 @FILES kmer_counts tmp #(requires KMC to be downloaded)
kmc_tools transform kmer_counts histogram kmer_k21.hist

# Extract kmer pairs
# Now we would like to build a database of all 21-mers using kmc
mkdir tmp # create a directory for temporary files
ls DRR013884_1.fastq.gz DRR013884_2.fastq.gz > FILES # create a file with both the raw read files
kmc -k21 -t16 -m64 -ci1 -cs10000 @FILES kmer_counts tmp # run kmc (requires KMC to be downloaded)

#I would like to see the kmer spectra first before deciding about L and U. It also help not to fall into the same trap as with the F. iinumae smudgeplot.
Rscript genomescope.R -i kmer_k21.hist -k 21 -p 2 -o . -n Fananassa_genomescope 10000

#extract all the kmers with coverage >Lx and <Ux.
L=$(smudgeplot.py cutoff kmer_k21.hist L) # Lower
U=$(smudgeplot.py cutoff kmer_k21.hist U) # Upper
kmc_dump -ci$L -cx$U kmer_counts /dev/stdout | smudgeplot.py hetkmers -o kmer_pairs


# 2. Generate a smudgeplot
#feed the coverage file to the R script that will plot the smudgeplot and estimate ploidy, specify input file (-i), output name (-o) and a title for the plot so you will know what are you looking at (argument -t).
#We also filter out one percent of kmers with the highest coverage (the quantile filter) since it makes a nicer zoom to relevant area of the figure
smudgeplot.py plot -o f_ananassa kmer_pairs_coverages.tsv