#!/bin/bash
echo "################################################################################################################" 
echo "                            IMPUTE PIPELINE VERSION 1 SCG4  Version date Feb 16 2018 SLURM VERSION" 
echo "                                     SCG4 utilizing parallel computation SLURM VERSION"
echo "                                              Aditya Ambati"
echo "                                           ambati@stanford.edu"
echo "################################################################################################################"

echo " Plink is splitting chromosomes - only autosomomes "
./PLINK_SPLIT_SLURM.sh $1
JOBID0=$(sbatch --export=ALL PLINK_SPLIT.sh)
if ! echo ${JOBID0} | grep -q "[1-9][0-9]*$"; then 
   echo "Job(s) submission failed."
   echo ${JOBID0}
   exit 1
else
   job0=$(echo ${JOBID0} | grep -oh "[1-9][0-9]*$")
fi

echo " Holding shapeit job for plink to finish splitting chromosome"
./SHAPEIT_ARRAY_TASK_SLURM.sh $1 $job0
JOBID1=$(sbatch --export=ALL shapeit_array.sh)
if ! echo ${JOBID1} | grep -q "[1-9][0-9]*$"; then 
   echo "Job(s) submission failed."
   echo ${JOBID1}
   exit 1
else
   job1=$(echo ${JOBID1} | grep -oh "[1-9][0-9]*$")
fi
echo " Holding impute tasks until shapeit jobs completes, each chromosome is imputed in 1mb chunks "
python IMPUTE_HEADCOMMAND_SLURM.py $1 $job1
