# Submit Multiple Independent Jobs

**Note:** This technique was developed to submit jobs to the cluster due to 
the job array being disabled long ago. With the switch to Slurm, the job array
is now available.

Consider the need to obtain random numbers across varying sample sizes and means.

$$
\mu = \begin{cases}
-1 \\
0 \\
2.5 \\
5
\end{cases}, \sigma = \begin{cases}
1 \\
2
\end{cases}
$$

## Sample Job script

**sim_job.R**

```r
--8<-- "slurm/scripts/sim_job.R"
```

Download a copy onto the cluster with:

```bash
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/sim_job.R

chmod +x sim_job.R
```

## Sample Parameter Inputs

**inputs.txt**

```bash
--8<-- "slurm/scripts/inputs.txt"
```

Download a copy onto the cluster with:

```bash
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/inputs.txt
```

**Note:** Parameters are best generated using `expand.grid()`. 

```r
N_vals = c(250, 500, 750)
mu_vals = c(0, 1.5)

sim_frame = expand.grid(N = N_vals, mu = mu_vals)
sim_frame
# 250 0.0
# 500 0.0
# 750 0.0
# 250 1.5
# 500 1.5
# 750 1.5
```

Write the simulation parameter configuration to `inputs.txt` with:

```r
write.table(sim_frame, file = "inputs.txt", 
            col.names = FALSE, row.names = FALSE)
```


## Faux Job Array Script

```bash
--8<-- "slurm/scripts/job_builder.sh"
```

Download a copy and run on the cluster with:

```bash
# Download a copy
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/job_builder.sh

# Enable the script to run.
chmod +x job_builder.sh

# Submit jobs to the queue
./job_builder.sh
```
