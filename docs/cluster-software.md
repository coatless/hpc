# Cluster Software

## Software Modules

Unlike a traditional desktop, you must load the different software that you
wish to use into the environment via `modulefiles`. The list of
supported software can be found on [Software List](https://campuscluster.illinois.edu/resources/software/)
or by typing:

```bash
module avail
```

## Viewing, Retrieving, and Disabling Module Software

```bash
module list              # See active software modules
module load <software>   # Enable software
module unload <software> # Disable software
module purge             # Removes all active modules
```

## Latest Version of _R_

As of **August 2020**, the latest version of _R_ on ICC is 
_R_ **3.6.2**. _R_ can be accessed by using^[
If the version is not specified during the load, e.g. `module load R`, then
the oldest version of _R_ will be used.]: 

```bash
module load R/3.6.2 # Load software
```

## Ask for Help

ICC's help desk (via <help@campuscluster.illinois.edu>)
can help install software on ICC. Please send them an e-mail and _CC_ your advisor.

### Writing a Custom Module

It is possible to compile and create your own modules.
For details, see the tutorial [A Modulefile Approach to Compiling _R_ on a Cluster](http://thecoatlessprofessor.com/programming/a-modulefile-approach-to-compiling-r-on-a-cluster/).
