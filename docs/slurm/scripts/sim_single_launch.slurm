#!/bin/bash

## Describe requirements for computing ----

## Name the job to ID it in squeue -u $USER
#SBATCH --job-name=myjobarray

## Send email on any change in job status (NONE, BEGIN, END, FAIL, ALL)
## Note: To be notified on each task on the array use: ALL,ARRAY_TASKS
#SBATCH --mail-type=ALL

## Email address of where the notification should be sent.
#SBATCH --mail-user=netid@illinois.edu

## Amount of time the job should run
## Note: specified in hour:min:sec, e.g. 01:30:00 is a 1 hour and 30 min job.
#SBATCH --time=00:10:00
## Request a single node
#SBATCH --ntasks=1
## Specify number of CPU cores for parallel jobs
## Note: Leave at 1 if not running in parallel.
#SBATCH --cpus-per-task=1
## Request a maximum amount of RAM per CPU core
## Note: For memory intensive work, set to a higher amount of ram.
#SBATCH --mem-per-cpu=5gb

## Setup computing environment for job ----

## Create a directory for the data output based SLURM_JOBID assigned to job
mkdir ${SLURM_SUBMIT_DIR}/${SLURM_JOBID}

## Switch directory into job ID (puts all output here)
cd ${SLURM_SUBMIT_DIR}/${SLURM_JOBID}

## Run simulation ----

## Load a pre-specified version of R
module load R/3.6.2

## Run R script in batch mode without file output
Rscript $HOME/sim_job.R --args 5 10
