#!/bin/bash
########################################################
# job_builder.sh
# Job Arrays without the Resource Manager
# Version 2.0.0
########################################################
# James Joseph Balamuta
# balamut2@illinois.edu
########################################################
# ## Example
#
# # Allow the builder script to work on the file system
# chmod +x job_builder.sh
#
# # Run the job builder
# ./job_builder.sh
########################################################


### Builds the job index
# Create a sequential range
array_values=`seq 1 3`

# Add individual job values
# Note: Have a "space" before first element!!!!
array_values+=" 4 5"

# Warning: This does _not_ pad numbers meaning job IDs created will _not_ be
# sorted appropriately on the file system

### Generate a Slurm file for each Job ID
# Modify the contents of the Slurm file to be relevant to your simulation

## Set the duration the job should run in hours:minutes:seconds form.
## Note: Submissions to secondary queue are limited to 4 Hours
WALLTIME=04:00:00
SIM_NAME=sample_job
SIM_OUTPUT=sample_job_output
SIM_QUEUE=secondary
SIM_RAM="2gb"
INPUT_CONFIG_FILE=\$HOME/input_params
R_VERSION=3.6.2
R_SCRIPT_FILE=\$HOME/sim_job.R
SLURM_FILE_NAME=sample_job_single

### -------- Do not modify below here   -------- ####

for i in $array_values
do

	cat > ${SLURM_FILE_NAME}${i}.slurm << EOF
#!/bin/bash
#
## Set the maximum amount of runtime
#SBATCH --time=${WALLTIME}
##
## Request one node with and one core (multiple under slurm is done with X*Y)
#SBATCH --ntasks=1
## Name the job and queue it in xthe secondary queue
#SBATCH --job-name="${SIM_NAME}${i}"
#SBATCH --partition="${SIM_QUEUE}"
## Declare an output log for all jobs to use:
#SBATCH --output="${SIM_NAME}.log"
#SBATCH --mem-per-cpu="${SIM_RAM}"
mkdir \$SLURM_SUBMIT_DIR/$SIM_OUTPUT
cd \$SLURM_SUBMIT_DIR/$SIM_OUTPUT
module load R/$R_VERSION
export PARAMS=\`cat $INPUT_CONFIG_FILE | sed -n ${i}p\`

R -q -f $R_SCRIPT_FILE --args \$PARAMS > data${i}
exit 0;

EOF
done

# Launch the job and then remove the temporarily created qsub file.
for i in $array_values
do
# This submits the single job to the resource manager
sbatch ${SLURM_FILE_NAME}${i}.slurm

# This removes the job file as Slurm reads the script at submission time
rm -rf ${SLURM_FILE_NAME}${i}.slurm
done
