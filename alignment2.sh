#!/bin/bash
#PBS -N variant_calling
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

source activate samtools
module load bwa
module load python
source activate gatk4

# Directories
ref="/ddn/home12/r2620/slu_fresh/alignment_2/Suillus_luteus_uh_slu_lm8_n1_gca_000827255.Suilu1.dna.nonchromosomal.fa"
aligned_reads="/ddn/home12/r2620/slu_fresh/alignment_2/aligned_reads"
reads="/ddn/home12/r2620/slu_fresh/reads"
results="/ddn/home12/r2620/slu_fresh/alignment_2/results"
data="/ddn/home12/r2620/slu_fresh/alignment_2/data"

############################################ Prep Steps ##############################################################
#if false
#then
#    echo "Run Prep Files..."
# Index and ref dict files only have to be generated once, then they can be used over and over
# Index the reference file (.fai file)
#    conda activate samtools
#    samtools faidx ~/ref/path/ref.fa

# Ref dict (.dict file)
#    conda activate gatk4
#    gatk CreateSequenceDictionary R=~/ref/path/ref.fa O=~/ref/path/ref.dict

# Would also download known sites of if available (they are not in this case, I will have to generate them)
#fi

####################################### Variant calling steps ########################################################

# -------------------------------
# STEP 1: Fastqc (quality check)
# -------------------------------
echo "Step 1: run fastqc"
module load fastqc
# Fastqc loop
for i in ${reads}*.trimmed.fastq.gz
do fastqc "$i" -o ~/slu_fresh/fastqcOut2/
done
## these reads were adapter trimmed prio to this step

# -------------------------------
# STEP 2: BWA (map to reference)
# -------------------------------
echo "Step 2: run BWA"
module load bwa
module load python
source activate samtools

# BWA index ref- this only needs to be done one time so not in the loop
bwa index ${ref}

#BWA alignment
# Loop through the R1_P files and perform BWA alignment
for R1_P in "${reads}"/*R1_P*
do
    # Extract the sample name from the R1_P file name
    sample_name=$(basename "$R1_P" "_R1_P.trimmed.fastq.gz")
    
    # Construct the path to the corresponding R2_P file
    R2_P="${reads}/${sample_name}_R2_P.trimmed.fastq.gz"
    
    # get the read group (for bwa mem -R)
    header=$(zcat "$R1_P" | head -n 1)
    id=$(echo "$header" | head -n 1 | cut -f 1-4 -d":" | sed 's/@//' | sed 's/:/_/g')
    sm=$(echo "$header" | head -n 1 | grep -Eo "[ATGCN]+$")
    echo "Read Group for ${sample_name} is @RG\tID:$id\tSM:$id"_"$sm\tLB:$id"_"$sm\tPL:ILLUMINA"
    
    # Run BWA alignment and sort the output BAM file
    bwa mem -t 8 -R "@RG\tID:$id\tSM:$id"_"$sm\tLB:$id"_"$sm\tPL:ILLUMINA" "${ref}" "${R1_P}" "${R2_P}" | samtools view -Sb - > "${aligned_reads}"/"${sample_name}".paired.bam
    
    echo "Generated alignment: ${sample_name}"
done

# -----------------------------------------
# STEP 3: GATK4 (mark duplicates and sort)
# -----------------------------------------
echo "Step 3: run GATK4 dedup"
for file in "${aligned_reads}"/*.bam
do
    # Extract the sample name from the R1_P file name
    sample_name=$(basename "$file" ".paired.bam")
    gatk MarkDuplicatesSpark -I "${file}" -O ${aligned_reads}/${sample_name}_sorted_dedup_reads.bam
    
    echo "Marked Duplicates for: ${sample_name}"
done

# -------------------------------------------
# STEP 4: GATK4 (base quality recalibration)
#   *if you dont have known variant sites (non model organism) you generate them by calling variants first without a BQR step then filtering variants to only high quality variants,
#       and using those as the input for the BQR step (bootstrapping)
# -------------------------------------------
echo "Step 4: run GATK4 recal"
# 1. build the model
gatk BaseRecalibrator -I ${aligned_reads}/${sample_name}_sorted_dedup_reads.bam -R ${ref} --known-sites ${known_sites} -O ${data}/recal_data.table
# 2. apply the model to adjust the base quality scores
gatk ApplyBQSR -I ${aligned_reads}/${sample_name}_sorted_dedup_reads.bam -R ${ref} --bqsr-recal-file ${data}/recal_data.table -O ${aligned_reads}/${sample_name}_sorted_dedup_bqsr_reads.bam
#### This gives analysis ready reads (ready to call variants)


# ----------------------------------------------------------
# STEP 5: GATK4 (collect alignment and insert size metrics)
# ----------------------------------------------------------
echo "Step 5: run GATK4 aligm metrics"
gatk CollectAllignmentSummaryMetrics R=${ref} I=${aligned_reads}/${sample_name}_sorted_dedup_bqsr_reads.bam O=${aligned_reads}/${sample_name}_alignment_metrics.txt
gatk CollectInsertSizeMetrics INPUT=${aligned_reads}/${sample_name}_sorted_dedup_bqsr_reads.bam OUTPUT=${aligned_reads}/${sample_name}_insert_size_metrics.txt HISTOGRAM_FILE=${aligned_reads}/${sample_name}_insert_size_histogram.pdf


# ----------------------------------------------------------
# STEP 6: GATK4 haplotype caller (call variants)
# ----------------------------------------------------------
echo "Step 6: run GATK4 haplotype caller"
gatk HaplotypeCaller -R ${ref} -I ${aligned_reads}/${sample_name}_sorted_dedup_bqsr_reads.bam -O ${results}/${sample_name}_raw_variants.vcf

# extract SNPs and INDELS
gatk SelectVariants -R ${ref} -V ${results}/raw_variants.vcf --select-type SNP -O ${results}/raw_snps.vcf
gatk SelectVariants -R ${ref} -V ${results}/raw_variants.vcf --select-type INDEL -O ${results}/raw_indels.vcf