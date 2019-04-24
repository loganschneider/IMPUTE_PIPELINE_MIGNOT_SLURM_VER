#!/bin/bash
command="./shapeit --input-bed "$1"_CHR\$SLURM_ARRAY_TASK_ID.bed "$1"_CHR\$SLURM_ARRAY_TASK_ID.bim "$1"_CHR\$SLURM_ARRAY_TASK_ID.fam \
-M /srv/gsfs0/projects/mignot/IMPUTE_REFERENCE_PHASE1/genetic_map_chr\$SLURM_ARRAY_TASK_ID\_combined_b37.txt \
-O "$1"_CHR\$SLURM_ARRAY_TASK_ID \
-T 8"
touch shapeit_array.sh
chmod 755 shapeit_array.sh
cat > shapeit_array.sh <<- EOF
#!/bin/bash -l
#SBATCH --job-name=shapeit_array
#SBATCH --mem-per-cpu=10000
#SBATCH --time=120:00:00
#SBATCH --array=1-22
#SBATCH --depend=afterok:"$2"
#SBATCH --cpus-per-task=4
#SBATCH --account=mignot
$command
EOF
#sbatch --export=ALL shapeit_array.sh
