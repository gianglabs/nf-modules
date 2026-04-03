/*
========================================================================================
    ALIGNMENT SUBWORKFLOW
========================================================================================
    QC, Trimming, Alignment
========================================================================================
*/


include { FASTP } from '../../../modules/gianglabs/fastp/trim/main'

workflow ALIGNMENT_FASTP {
    take:
    reads_ch // channel: [ val(meta), [ path(read1), path(read2) ] ]
    ref_fasta // path: reference FASTA
    ref_fai // path: reference FAI
    ref_dict // path: reference dict
    bwa2_index // channel: Optional BWA index files
    index_bwa2_reference // channel: Optional BWA index files

    main:
    ch_versions = channel.empty()
    FASTP(
        reads_ch
    )
    ch_versions = ch_versions.mix(FASTP.out.versions)
}
