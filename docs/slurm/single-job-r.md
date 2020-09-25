# Single Independent R Job

Consider the need to obtain random numbers across varying sample sizes and means.

$$N = \begin{cases}
250 \\
500 \\
750 
\end{cases}, \mu = \begin{cases}
0 \\
1.5
\end{cases}$$

## Sample Job Script

**sim_job.R**

```r
--8<-- "slurm/scripts/sim_job.R"
```

Download a copy and run it on the cluster with:

```bash
# Download a copy of the script onto the cluster
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/sim_job.R

# Execute the script with parameter values
Rscript $HOME/sim_job.R --args 5 10
# [1]  9.006482 11.288477 11.109700 12.280027  9.500943
```

## Sample Slurm Submission File

**sim_single_launch.slurm**

```bash
--8<-- "slurm/scripts/sim_single_launch.slurm"
```

```bash
# Download a copy of the script onto the cluster
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/sim_single_launch.slurm

# Queue the job on the Cluster
sbatch sim_single_launch.slurm
```




