#!/bin/bash
#SBATCH --job-name='03_filter.sh'
#SBATCH --cpus-per-task=32
#SBATCH --mem=232GB
#SBATCH --output=./logs/out.log
#SBATCH --error=./logs/err.log
#SBATCH --time=96:00:00

JOBLOG="./logs/03_filter.log"
INPATTERN="~/scratch/v4/02_rsids/v4.chr{}.rs.vcf.gz"
OUTPATTERN="~/scratch/v4/03_filtered/v4.chr{}.sn.vcf.gz"
SCRIPTNAME="03_filter.sh"

if [[ $(hostname -s) = slurm-login ]]; then
    echo "don't run on headnode!"
    echo "${SCRIPTNAME}"
    exit 1
elif (( $# == 0 )); then
    >&1 echo "0 parameters.. running parallel"
    echo "Launching SLURM job on $HOSTNAME" >> $JOBLOG
    seq 1 22 | parallel ./${SCRIPTNAME} $INPATTERN $OUTPATTERN 
elif (( $# == 2 )); then
    MSG="inner script: $1 $2"
    INFILE=$1
    OUTFILE=$2
    echo $MSG >> $JOBLOG
    bcftools view \
     -v snps,indels \
     --min-ac 3 \
     --max-alleles 2 \
     $INFILE \
     -Oz -o $OUTFILE
     tabix $OUTFILE
else
    >&2 echo "unknown number of parameters"
fi

: '
# This is a multiline comment
# copy/paste the following to launch parallel


'
