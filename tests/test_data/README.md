# Test Data

This directory contains test data files used for testing modules in nf-modules.

## Structure

```
test_data/
└── genomics/
    └── homo_sapiens/
        ├── bam/           # Test BAM/CRAM files
        ├── fastq/         # Test FASTQ files
        └── reference/     # Reference genome files
```

## Usage

To use local test data, set the environment variable:
```bash
export MODULES_TESTDATA_BASE_PATH="tests/test_data/"
```

Or use the default path which is already configured in `tests/config/nf-test.config`.

## Test Files

### FASTQ Files
- `HG002_subset_R1.fastq.gz` - Paired-end read 1 (subset of HG002 sample)
- `HG002_subset_R2.fastq.gz` - Paired-end read 2 (subset of HG002 sample)

### Reference Files
- `chr22.fasta` - Human chromosome 22 reference
- `chr22.fasta.fai` - FASTA index

### Alignment Files
- `test.cram` - Test CRAM file
- `test.cram.crai` - CRAM index

## Note

These test files are subsets of larger datasets and are meant for testing purposes only.
For production use, please use full datasets and appropriate reference genomes.
