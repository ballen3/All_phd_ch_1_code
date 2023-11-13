#!/bin/bash
#PBS -N busco_10
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

#activate the conda env with busco
source activate busco-5.5.0

#files
scaffolds="$HOME/practice_code/practice_spades_out/10_FD_12198.2.244246.GGACTGT-AACAGTC/10_FD_12198.2.244246.GGACTGT-AACAGTC_spades_scaffolds.fasta.gz"
output="./10_busco_output"

filename=$(basename "$scaffolds")
sample_name="${filename%.*}"

# Run busco
# Extract the compressed file before passing it to BUSCO
gunzip -c "$scaffolds" > "${output}/${sample_name}"
busco -i "${output}/${sample_name}" -l boletales_odb10 -o "${output}/${sample_name}.busco" -m genome -f --offline --download_path ~/slu_raw/deinterleaved_slu/busco_downloads/


#-m is mode, geno= genome
#-f force (add this if you need to run it again and rewrite files with the same name as what you want to use)
#-i is input
#-l The path to the BUSCO database file (on the BUSCO website)
#-o output

## has companion scripts for plotting, useful for supplementary info (https://busco.ezlab.org/busco_userguide.html#running-busco)





### For single file testing ###
#!/bin/bash
#PBS -N busco_120.test
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
#cd "${PBS_O_WORKDIR}" || exit

#activate the conda env with busco
#source activate busco-5.5.0

# Run busco
# Extract the compressed file before passing it to BUSCO
#busco -i ~/slu_fresh/spades_tests/120_test/120_scaffolds.fasta -l boletales_odb10 -o ~/slu_fresh/busco_test/120_test/120.busco" -m genome -f --offline --download_path ~/slu_raw/deinterleaved_slu/busco_downloads/


