# NF4LS: Data and environment setup

This repo is a [mirror](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository#mirroring-a-repository)
of the [Nextflow for the Life Sciences](https://github.com/Sydney-Informatics-Hub/hello-nextflow-2025) workshop.

This repo is used to setup a new environment with the dependencies, data, and file structure required to run the workshop.

## Minimum requirements

Install instructions are suitable for systems that meet the following:

- Ubuntu vX.XX
- 2GB 4CPU

As there are no intensive data-processing steps, 2GB 4CPU is sufficient for one user

## Installation and setup

Each learner should have their own machine or user account.

```bash
git clone nf4ls-data && \
cd nf4ls-data && \
./install.sh
```

This will:

1. Install required dependencies (Nextflow, singularity)
2. Pre-pull containers
3. Prepare file structure and all required input files for the workshop

### File structure

This is how the files should look like after installation, and upon workshop start:

```console
${HOME}/
├── part1 # Empty
├── part2
│   ├── bash_scripts
│   │   ├── 00_index.sh
│   │   ├── 01_fastqc.sh
│   │   ├── 02_quant.sh
│   │   └── 03_multiqc.sh
│   ├── data
│   │   ├── ggal
│   │   │   ├── gut_1.fq
│   │   │   ├── gut_2.fq
│   │   │   ├── liver_1.fq
│   │   │   ├── liver_2.fq
│   │   │   ├── lung_1.fq
│   │   │   ├── lung_2.fq
│   │   │   └── transcriptome.fa
│   │   ├── samplesheet.csv
│   │   └── samplesheet_full.csv
│   ├── main.nf
│   ├── .main.nf
│   └── .nextflow.config
└── singularity
    ├── fastqc 
    ├── salmon
    └── multiqc
```

part1 is empty as learners will create scripts from scratch.

part2 contains bash_scripts for viewing (not running) and test input data of RNA-seq and a transcriptome obtained from Seqera training.
