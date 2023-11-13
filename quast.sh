#!/bin/bash
#PBS -N quast1
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

#load quast from maple
#actually quast version 5.2.0
source activate quast-4.6.3

#files
#contigs="$HOME/practice_code/77_output_dir/77_spades_contigs.fasta.gz"
scaffolds=($HOME/slu_raw/deinterleaved_slu/scaffolds/*_scaffolds.fasta.gz)
ref="$HOME/ref_slu/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa.gz"
gff="$HOME/ref_slu/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.56.gff3.gz"
output="$HOME/slu_raw/scaffolds/scaff_quast_output"

#run quast

filename=$(basename "${scaffolds[@]}")
sample_name="${filename%.*}"

echo "Running QUAST for ${sample_name}"

quast.py \
-o "${output}/${sample_name}" \
--threads 8 \
-e \
--fungus \
-g "${gff}" \
--fragmented \
-r "${ref}" \
-s "${scaffolds[@]}"

echo "QUAST for ${sample_name} done!"
