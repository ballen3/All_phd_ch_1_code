#! /usr/bin/bash/ nextflow

/*
 * Generate antismash .gff files
 */

process antismash {
    
    conda 'antismash'

    publishDir params.outdir, mode: 'symlink'

    input:
        path input_asmash
        path input_annotations
        val sample_name
    
    output:
        path "$input_asmash-output.gff" , emit: gff3
        val
    
    script:
    """
    antismash "$input_asmash" \
    --taxon fungi \
    --output-dir "$antismash_out"/"${sample_name}" \
    --output-basename "${sample_name}" \
    --cb-general --cb-knownclusters --cb-subclusters \
    --asf --pfam2go --clusterhmmer --cassis --cc-mibig --tfbs \
    --genefinding-gff3 "$input_annotations"/"${sample_name}"_spades_scaffolds.fasta.gff
    
    """
}