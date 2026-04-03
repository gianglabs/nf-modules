process FASTP {
    tag "${meta.id}"
    label 'process_medium'
    container 'quay.io/biocontainers/fastp:1.1.0--heae3180_0'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*_trimmed_{1,2}.fastq.gz"), emit: reads
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.json"), emit: json
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.read_group}"

    """
    echo 1 > ${prefix}_trimmed_1.fastq.gz
    echo 1 > ${prefix}_trimmed_2.fastq.gz
    echo 1 > ${prefix}_fastp.html
    echo 1 > ${prefix}_fastp.json
    
    # Create versions file
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastp: \$(fastp --version 2>&1 | grep -oP 'fastp \\K[0-9.]+')
    END_VERSIONS
    """
}
