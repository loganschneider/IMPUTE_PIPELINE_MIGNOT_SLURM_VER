#!/bin/bash
echo "################################################################################################################" 
echo "#                            IMPUTE PIPELINE VERSION 1 SCG4  Version date August 2019 SLURM VERSION            #"
echo "#                                     SCG4 utilizing parallel computation SLURM VERSION 2                      #"
echo "#                                              Aditya Ambati                                                   #"
echo "#                                           ambati@stanford.edu                                                #"
echo "################################################################################################################"

echo "`date` STARTING IMPUTATION "
echo " `date` CHECKING IF PLINK FILES SPLIT BY CHR EXIST in CURRENT DIR  "
if [[ -f $PWD/${w}_CHR2.bed ]];then
   echo " `date` PLINK FILES HAVE ALREADY BEEN SPLIT >>>> PROCEEDING TO SHAPEIT TASK"
   if  [[ -f $PWD/${w}_CHR2.haps ]];then
      ./SHAPEIT_ARRAY_TASK_SLURM.sh $1 $job0
      JOBID1=$(sbatch --export=ALL shapeit_array.sh)
      if ! echo ${JOBID1} | grep -q "[1-9][0-9]*$"; then 
         echo "`date` Job(s) submission failed."
         echo ${JOBID1}
         exit 1
      else
         job1=$(echo ${JOBID1} | grep -oh "[1-9][0-9]*$")
      fi
      echo "`date` GENOTYPES HAVE BEEN PHASED >>>> PROCEEDING TO IMPUTATION"
      python IMPUTE_HEADCOMMAND_SLURM.py $1 $job1
   else
      echo "`date` PHASED GENOTYPES HAVE BEEN FOUND >>>> PROCEEDING TO IMPUTATION"
      job1=000
      python IMPUTE_HEADCOMMAND_SLURM.py $1 $job1
   fi
else
   echo "`date` PLINK FILES ARE BEING SPLIT BY CHR"
   ./PLINK_SPLIT_SLURM.sh $1
   JOBID0=$(sbatch --export=ALL PLINK_SPLIT.sh)
   if ! echo ${JOBID0} | grep -q "[1-9][0-9]*$"; then 
      echo "Job(s) submission failed."
      echo ${JOBID0}
      exit 1
   else
      job0=$(echo ${JOBID0} | grep -oh "[1-9][0-9]*$")
   fi
   echo "`date` PHASING WITH SHAPEIT "
   ./SHAPEIT_ARRAY_TASK_SLURM.sh $1 $job0
   JOBID1=$(sbatch --export=ALL shapeit_array.sh)
   if ! echo ${JOBID1} | grep -q "[1-9][0-9]*$"; then 
      echo "Job(s) submission failed."
      echo ${JOBID1}
      exit 1
   else
      job1=$(echo ${JOBID1} | grep -oh "[1-9][0-9]*$")
   fi
   date
   echo "`date` GENOTYPES HAVE BEEN PHASED >>>> PROCEEDING TO IMPUTATION"
   python IMPUTE_HEADCOMMAND_SLURM.py $1 $job1
fi
