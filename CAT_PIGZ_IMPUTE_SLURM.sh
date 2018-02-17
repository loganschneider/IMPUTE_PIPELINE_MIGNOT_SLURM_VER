#!/bin/bash
touch CAT_IMPUTE_PIGZ.sh
chmod 755 CAT_IMPUTE_PIGZ.sh
cat > 755 CAT_IMPUTE_PIGZ.sh <<- EOF
#!/bin/bash -l
#SBATCH --job-name=catimpute_files
#SBATCH --mem-per-cpu=4000
#SBATCH --array=1-22
#SBATCH --account=mignot
#SBATCH --time=12:00:00
mkdir impute_info
module load pigz/2.3.4
mv CHR$SLURM_ARRAY_TASK_ID_"$1".*_* impute_info/
cat CHR$SLURM_ARRAY_TASK_ID_"$1".* > CHR$SLURM_ARRAY_TASK_ID_"$1".impute2
pigz CHR$$SLURM_ARRAY_TASK_ID_"$1".impute2
EOF

