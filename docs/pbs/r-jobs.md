# R

## Sample simulation script

```r
# Expect command line args at the end.
args = commandArgs(trailingOnly = TRUE)
# Skip args[1] to prevent getting --args

# Extract and cast as numeric from character
rnorm(n = as.numeric(args[2]), mean = as.numeric(args[3]))
```

## Script with Fixed Parameters

```bash
#!/bin/bash

## Describe requirements for computing ----

## Set the maximum amount of runtime to 4 Hours
#PBS -l walltime=04:00:00
## Request one node with `nodes` and one core with `ppn`
#PBS -l nodes=1:ppn=1
#PBS -l naccesspolicy=shared
## Name the job
#PBS -N jobname
## Queue in the secondary queue
#PBS -q secondary
## Merge standard output into error output
#PBS -j oe

## Setup computing environment for job ----

## Create a directory for the data output based ## on PBS_JOBID
mkdir ${PBS_O_WORKDIR}/${PBS_JOBID}

## Switch directory into job ID (puts all output here)
cd ${PBS_O_WORKDIR}/${PBS_JOBID} # Load R

## Run simulation ----

## Load latest version of R loaded
module load R/3.6.2

## Run R script in batch mode without file output
Rscript $HOME/sim_runner.R --args 5 10
```
