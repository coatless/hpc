# Bash

## Single script

**sim-script.sh**

```bash
#!/bin/bash

## Ensure that only 2 parameters are passed in ----
if [ $# -ne 2 ]; then
    echo "$0: usage: ./sim-script param1 param2"
    exit 1
fi

# Retrieve parameters passed in
param1 = $1
param2 = $2

echo "param1 = ${param1}; param2 = ${param2}"
```

- `$#`: number of arguments passed;
- `$0`: name of the shell or shell script;
- `$1`: the first argument;
- `$n`: the nth argument (substitute n with number); 
- `$*`: all arguments, space issues if unquoted, use `"$@"`; 
- `$@`: all arguments, expands to separate words; or
- (**Bonus**) `$?`: Exit status of last script (0 is success).

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

