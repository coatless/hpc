# Array Submission of Multiple Independent R Jobs

Consider the need to obtain random numbers across varying sample sizes and means.

$$\mu = \begin{cases}
-1 \\
0 \\
2.5 \\
5
\end{cases}, \sigma = \begin{cases}
1 \\
2
\end{cases}$$

## Sample simulation script

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


## Script with Fixed Parameters

**sim_array_launch.slurm**

```bash
--8<-- "slurm/scripts/sim_array_launch.slurm"
```

Download a copy onto the cluster with:

```bash
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/sim_array_launch.slurm
```

**Note:** `%A` will be replaced by the value of the `SLURM_ARRAY_JOB_ID` environment
variable and `%a` will be replaced by the value of `SLURM_ARRAY_TASK_ID` environment
variable. For example, `SLURM_ARRAY_JOB_ID` corresponds to the number assigned
to the job in the queue and `SLURM_ARRAY_TASK_ID` relates to a value in the
job array. In the case of this example, the `SLURM_ARRAY_TASK_ID` would take
on values from 1 to 6.


