#!/bin/bash

# Calls the four steps (maxlam, cv, refit, summary) in sequence via the slurm script

script_path="one_job.slurm"

jid1=$(sbatch --parsable --export=cv_step='maxlam' --job-name=maxres --array=1 "$script_path")
jid2=$(sbatch --parsable --dependency=afterok:$jid1 --export=cv_step='cv' --job-name=cv --array=1-5000%300 "$script_path")
# In practice, random CV jobs may fail due to running too many jobs at once, so you may need to rerun some jobs between 
# these two steps
jid3=$(sbatch --parsable --dependency=afterok:$jid2 --export=cv_step='refit' --job-name=refit --array=1-100 "$script_path")
sbatch --dependency=afterok:$jid3 --export=cv_step='summary' --job-name=summary --array=1 "$script_path"