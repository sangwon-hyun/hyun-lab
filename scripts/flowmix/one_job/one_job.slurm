#!/bin/bash

# Example of a SLURM script which can be 
# used to run the simulations

# You may want to change some of these settings. For example,
#   - increase --cpus-per-task for more parallelization.
#   - Put your email in --mail-user to get notified of changes in job status
#   - use partition, account, and qos to make sure you're using the proper 
#   - resource allocation

#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB
#SBATCH --time=01-00:00:00
#SBATCH --output=./logs/%x_%A_%a.log
#SBATCH --error=./logs/%x_%A_%a.err
#SBATCH --job-name=one_job
# #SBATCH --partition=...
# #SBATCH --account=...
# #SBATCH --qos=...
# #SBATCH --mail-user=...
# #SBATCH --mail-type=...

###

# On UCSC HPC, hard-coding the path to R executable is more robust
# than loading a conda environment, which sometimes fails randomly
R_BIN=/path/to/bin/Rscript

###

${R_BIN} one_job.R ${cv_step} ${SLURM_ARRAY_TASK_ID}
