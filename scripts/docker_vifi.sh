#!/bin/bash
INPUT_DIR=$1
READ1=$2
READ2=$3
OUTPUT_DIR=$4
CPUS=${5:-1}

SINGULARITYENV_CPUS=$CPUS SINGULARITYENV_READ1=$READ1 SINGULARITYENV_READ2=$READ2 singularity run --bind $REFERENCE_REPO:/home/repo/data --bind $INPUT_DIR:/home/fastq/ --bind $AA_DATA_REPO:/home/data_repo/ --bind $OUTPUT_DIR:/home/output/ vifi:latest sh /home/vifi.sh

