# R

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

**Note:** Parameters are best generated using `expand.grid()`. Consider the
need to obtain random numbers across varying sample sizes and means.

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

Download a copy onto the cluster with:

```bash
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/slurm/scripts/job_builder.sh

chmod +x job_builder.sh
```
