# Bash

## Script with Fixed Parameters

```bash
#!/bin/bash

## Describe requirements for computing ----
#PBS -q secondary 
#PBS -l nodes=1:ppn=1
#PBS -l walltime=04:00:00

## Set variables ----
param1 = 1
param2 = 2

## Start simulation study ----
cd ~/sim-dir
./sim-script param1 param2
```

## Script with Varying Parameters

```bash
#!/bin/bash

## Describe requirements for computing ----
#PBS -q secondary 
#PBS -l nodes=1:ppn=1 
#PBS -l walltime=04:00:00

## Set array variables ----
param1 = ({1, 2, 3})
param2 = ({4, 5, 6})

## Start simulation study ----
cd ~/sim-dir
for ((i=0;i<${#param[@]};++i)); do
    ./sim-script ${param1[i]} ${param2[i]}
done
```

## Parallelized Script with Varying Parameters

```bash
#!/bin/bash

## Describe requirements for computing ----
#PBS -q secondary 
#PBS -l nodes=1:ppn=3 
#PBS -l walltime=04:00:00

## Set array variables ----
param1=({1,2,3})
param2=({4,5,6})

## Start simulation study ----
cd ~/sim-dir

## Run simulations in parallel ----
for ((i=0;i<${#param[@]};++i)); do
    ./sim-script ${param1[i]} ${param2[i]} & # Ampersand runs script in background
    process_id[i]=$!                         # Store the Process ID
done

## Wait for all processes to complete ----
for ((i=0;i<${#param[@]};++i)); do
    echo "Awaiting results for ${process_id[i]}."
    wait ${process_id[i]}
done
```

