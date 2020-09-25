# Single Independent R Job

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

## Sample simulation script

```r
--8<-- "slurm/scripts/sim_job.R"
```

## Script with Fixed Parameters

```bash
--8<-- "slurm/scripts/sim_single_launch.slurm"
```
