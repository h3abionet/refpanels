#!/bin/bash
#SBATCH --job-name='01_clean'
#SBATCH --cpus-per-task=32
#SBATCH --mem=232GB
#SBATCH --output=./logs/out.log
#SBATCH --error=./logs/err.log
#SBATCH --time=96:00:00

JOBLOG="./logs/01_clean.log"
INPATTERN="~/scratch/v4/00_original/v4.cgp.vf.va.{}.filter-pass.vcf.gz"
OUTPATTERN="~/scratch/v4/01_cleaned/v4.chr{}.cln.vcf.gz"
SCRIPTNAME="01_clean.sh"
SAMPLES="./input/v4.all.samples"

if [[ $(hostname -s) = slurm-login ]]; then
    echo "don't run on headnode!"
    echo "${SCRIPTNAME}"
    exit 1
elif (( $# == 0 )); then
    >&1 echo "0 parameters.. running parallel"
    echo "Launching SLURM job on $HOSTNAME" >> $JOBLOG
    seq 1 22 | parallel ./${SCRIPTNAME} $INPATTERN $OUTPATTERN 
elif (( $# == 2 )); then
    >&1 echo "2 parameters, running actual script"
    INFILE=$1
    OUTFILE=$2
    echo "$HOSTNAME $INFILE $OUTFILE" >> $JOBLOG
    bcftools view \
        --samples-file $SAMPLES \
        $INFILE \
  | bcftools annotate \
    -x INFO/AC,INFO/AF,INFO/AN,^INFO/DP,^INFO/QD,^INFO/VQSLOD,FORMAT/PS \
    - \
    -Oz -o $OUTFILE
    tabix $OUTFILE
else
    >&2 echo "unknown number of parameters"
fi

