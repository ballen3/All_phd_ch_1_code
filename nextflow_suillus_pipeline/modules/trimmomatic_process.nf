#! /usr/bin/bash/ nextflow

/*
 * trim( removes adapters from the raw reads)
 */

process trim {
    
    conda 'trimmomatic'

    publishDir params.outdir, mode: 'symlink'

    input:
        path f1 
        path f2
        val sample_name
    
    output:
        path "$input_raw-trimmed" 
        val
    
    script:
    """
    java -jar trimmomatic-0.39.jar \
    PE -phred33 \
    -threads 4 \
    "$f1" "$f2" \
    "${f1%.fastq.gz}""_P.trimmed.fastq.gz" "${f1%.fastq.gz}""_U.trimmed.fastq.gz" \
    "${f2%.fastq.gz}""_P.trimmed.fastq.gz" "${f2%.fastq.gz}""_U.trimmed.fastq.gz" \
    ILLUMINACLIP:./TruSeq3-PE-2.fa:2:30:10 \
    LEADING:20 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:50 \
    2>&1 | tee trimmomatic.log
    
    """
}