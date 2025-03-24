#! /usr/bin/bash/ nextflow



workflow {
    
/*
 * Pipeline parameters
 */

// Primary input
params.assemblies = "/ddn/home12/r2620/slu_fresh/assemblies/high_buscos"
params.outdir    = "/ddn/home12/r2620/slu_fresh/antismash/as_output"
params.raw = "input_raw~/slu_fastq/*.fastq.gz"


    // Create input channel (single file via CLI parameter)
    assemblies_ch = Channel.fromPath(params.assemblies)

    // antismash process
    antismash(assemblies_ch)

}