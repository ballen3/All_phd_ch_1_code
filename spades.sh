#!/bin/bash
#PBS -N Spades2
#PBS -j oe
#PBS -l ncpus=64
#PBS -l mem=50gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

# load module
module load spades

# changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

# run SPADdes with default parameters
for i in *.trimmed.fastq.gz;
do
    out=${i%.trimmed.fastq.gz}_spadesOut
    #
    mkdir ~/slu_spadesOut/"$out"
    spades.py -t 8 --careful -o ~/slu_spadesOut/"$out" --12 "$i";
    
    # change to out directory and rename outputs
    # if you dont change directories, it puts the renamed files in the directory you started in/ran this from because of `cd "${PBS_O_WORKDIR}"` (i think, still to be tested)
    cd ~/slu_spadesOut/"$out"/ || exit
    mv ~/slu_spadesOut/"$out"/contigs.fasta "${i%.trimmed.fastq.gz}"_spades_contigs.fasta
    mv ~/slu_spadesOut/"$out"/scaffolds.fasta "${i%.trimmed.fastq.gz}"_spades_scaffolds.fasta
    mv ~/slu_spadesOut/"$out"/spades.log "${i%.trimmed.fastq.gz}"_spades_prgm.log
    mv ~/slu_spadesOut/"$out"/contigs.paths "${i%.trimmed.fastq.gz}"_spades_contigs.paths
    mv ~/slu_spadesOut/"$out"/scaffolds.paths "${i%.trimmed.fastq.gz}"_spades_scaffolds.paths
    mv ~/slu_spadesOut/"$out"/assembly_graph_with_scaffolds.gfa "${i%.trimmed.fastq.gz}"_spades_assembly_graph.gfa
    mv ~/slu_spadesOut/"$out"/assembly_graph_after_simplification.gfa "${i%.trimmed.fastq.gz}"_spades_assembly_graph_after_simplification.gfa
    mv ~/slu_spadesOut/"$out"/assembly_graph.fastg "${i%.trimmed.fastq.gz}"_spades_assembly_graph.fastg
    
    # tar the out file and then remove the non-tar file (to save on space)
    tar -zcvf "$out".tar.gz ~/slu_spadesOut/"$out" --remove-files
done


# spades is the assembly step
# Run on trimmed reads (out of trimmomatic)
# `*.trimmed.fastq.gz` is in the directory that i run this script from, `cd "${PBS_O_WORKDIR}"` means to run the script in the pwd in the command line

# (NOT ON THE HPCWOODS SERVER IT WAS BEING STUPID) using an old version of SPADES (3.11.1), which handles heterozygozity better than the newer versions
# ${i%.trimmed.fastq.gz} - Removes the shortest string from the right side that matches the pattern.
# -t 8 because i read something that says SPAdes doesnt scale efficiently beyond something like 4-8 threads, so to cap threads at 8
# --12 is for files with interlaced (interleaved) forward and reverse paired-end reads (R1 and R2 are in one file instead of two separate files).
# --careful tries to reduce the number of mismatches and short indels.

# put echo after do to print for test run





