#!/bin/bash 
command="plink --bfile "$1" --chr \$SLURM_ARRAY_TASK_ID --make-bed --out "$1"_CHR\$SLURM_ARRAY_TASK_ID"
touch PLINK_SPLIT.sh
chmod 755 PLINK_SPLIT.sh
echo \#\!/bin/bash -l >PLINK_SPLIT.sh
echo \#SBATCH --job-name=PLINK_SPLIT_CHR >>PLINK_SPLIT.sh
echo \#SBATCH --mem-per-cpu=4000 >>PLINK_SPLIT.sh
echo \#SBATCH --time=01:00:00 >>PLINK_SPLIT.sh
echo \#SBATCH --array=1-22 >>PLINK_SPLIT.sh
echo \#SBATCH --account=mignot >>PLINK_SPLIT.sh
echo "module load plink/1.90" >>PLINK_SPLIT.sh
echo $command >> PLINK_SPLIT.sh
#sbatch --export=ALL PLINK_SPLIT.sh
