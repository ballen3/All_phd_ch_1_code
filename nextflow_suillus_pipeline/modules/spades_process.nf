#! /usr/bin/bash/ nextflow

/*
 * spades assembly
 */

process spades {
    
    conda 'spades'

    publishDir params.outdir, mode: 'symlink'

    input:
        path forward_reads = [file_name for file_name in files if "R1_P" in file_name]
        path reverse_reads = [file_name for file_name in files if "R2_P" in file_name]
        path forward_unpaired_reads = [file_name for file_name in files if "R1_U" in file_name]
        path reverse_unpaired_reads = [file_name for file_name in files if "R2_U" in file_name]
        val sample_name
    
    output:
        path "$sample_name-spades_scaffolds.fasta" , emit: scaffolds.fasta
        val ?
    
    script:
    """
    spades.py -t 8 --careful --pe1-1 ./{$sample_name} --pe1-2 ./{$sample_name} --s1 ./{$sample_name} --s1 ./{$sample_name} -o {$sample_name}_output
    
    # I think this can all be done in nextflow outputs/params/etc
    # only really need the scaffolds.fasta
    cd {$sample_name}_output || exit
    mv contigs.fasta {$sample_name}_spades_contigs.fasta 
    mv scaffolds.fasta {$sample_name}_spades_scaffolds.fasta
    mv spades.log {$sample_name}_spades_prgm.log
    mv contigs.paths {$sample_name}_spades_contigs.paths
    mv scaffolds.paths {$sample_name}_spades_scaffolds.paths
    mv assembly_graph_with_scaffolds.gfa {$sample_name}_spades_assembly_graph.gfa
    mv assembly_graph_after_simplification.gfa {$sample_name}_spades_assembly_graph_after_simplification.gfa
    mv assembly_graph.fastg {$sample_name}_spades_assembly_graph.fastg
    gzip -r {$sample_name}_spades_*
    
    """
}