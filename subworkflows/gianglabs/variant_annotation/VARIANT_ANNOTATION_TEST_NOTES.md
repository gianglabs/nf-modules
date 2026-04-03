# Variant Annotation Test Limitations

## Overview
The `variant_annotation` subworkflow test in `/subworkflows/gianglabs/variant_annotation/tests/main.nf.test` has infrastructure requirements that cannot be fully satisfied in standard testing environments.

## Issue
The variant_annotation workflow includes two annotation tools with substantial data requirements:

1. **snpEff**: Requires a genome database (e.g., `hg38`, `GRCh38.99`)
   - These databases are provided by snpEff but require download and installation
   - Size: 100+ MB per genome database
   - Location: snpEff expects them in a standard installation directory

2. **VEP (Variant Effect Predictor)**: Requires a VEP cache directory
   - Cache files are Ensembl genome-specific data
   - Size: 1-5 GB depending on species/assembly
   - Location: Must be downloaded from Ensembl

## Current Test Status
- ✅ Test framework is set up and creates proper snapshots
- ✅ VCF input files are properly prepared
- ❌ Annotation processes fail due to missing databases

### Error Messages
```
snpEff: RuntimeException: Property: 'snpeff_hg38.genome' not found in config file
VEP: Cannot find cache directory structure
```

## Solutions for Different Environments

### Option 1: CI/CD with Stub Processes (Recommended)
Use Nextflow stub runs to bypass actual annotation:
```nextflow
process {
    withName: 'VARIANT_ANNOTATION:SNPEFF' {
        stub {
            """
            touch ${meta.id}.ann.vcf
            touch ${meta.id}.csv
            touch ${meta.id}.html
            touch ${meta.id}.genes.txt
            cat <<-END_VERSIONS > versions.yml
            "${task.process}":
                snpeff: 5.4c
            END_VERSIONS
            """
        }
    }
}
```

### Option 2: Local Development with Downloaded Caches
Download the required databases:
```bash
# snpEff database
cd snpEff && ./scripts/downloadDb.sh -c hg38

# VEP cache (requires significant disk space)
vep_install -a cf -s homo_sapiens -y GRCh38 -c /path/to/vep_cache
```

### Option 3: Docker/Singularity with Pre-built Images
Use container images that have databases pre-installed:
```bash
singularity build vep_snpeff.sif docker://myregistry/vep-snpeff:latest
```

## Migration Notes
This test was migrated from the `nf-germline-short-read-variant-calling` pipeline. In that pipeline, annotation databases were expected to be available in the runtime environment or via external S3 buckets.

## Test Framework Files
- `/subworkflows/gianglabs/variant_annotation/tests/main.nf.test` - Main test file
- `/tests/test_data/genomics/homo_sapiens/caches/snpeff_hg38/` - Empty snpEff directory
- `/tests/test_data/genomics/homo_sapiens/caches/vep_cache/` - Empty VEP directory
- `/tests/config/nf-test.config` - Test configuration

## Next Steps
1. Implement stub runs for CI/CD pipeline
2. Create workflow documentation for users setting up annotation
3. Consider adding option for skipping annotation in test mode
