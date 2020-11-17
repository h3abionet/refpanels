#!/bin/bash
#SBATCH --job-name='02_add_rsids'
#SBATCH --cpus-per-task=32
#SBATCH --mem=232GB
#SBATCH --output=./logs/out.log
#SBATCH --error=./logs/err.log
#SBATCH --time=96:00:00

JOBLOG="./logs/02_add_rsids.log"
INPATTERN="~/scratch/v4/01_cleaned/v4.chr{}.cln.vcf.gz"
OUTPATTERN="~/scratch/v4/02_rsids/v4.chr{}.rs.vcf.gz"
SCRIPTNAME="02_add_rsids.sh"


if [[ $(hostname -s) = slurm-login ]]; then
    echo "don't run on headnode!"
    echo "${SCRIPTNAME}"
    exit 1
elif (( $# == 0 )); then
    >&1 echo "0 parameters.. running parallel"
    echo "Launching SLURM job on $HOSTNAME" >> $JOBLOG
    seq 1 22 | parallel ./${SCRIPTNAME} $INPATTERN $OUTPATTERN 
elif (( $# == 2 )); then
    MSG=$(date -u) "inner script: $1 $2"
    INFILE=$1
    OUTFILE=$2
    echo $MSG >> $JOBLOG
    java -jar ~/bin/SnpSift.jar annotate \
    -c ~/snpEff/snpEff.config \
    ~/scratch/dbs/dbSNP154.rsids.b37.vcf.gz $INFILE | \
    bgzip > $OUTFILE
    tabix $OUTFILE
else
    >&2 echo "unknown number of parameters"
fi

: '
# This is a multiline comment
# copy/paste the following to launch parallel


sbatch --dependency=afterok:

'
