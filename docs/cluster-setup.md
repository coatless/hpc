# Cluster Setup

Within this chapter, we will cover establishing a workspace on the Campus Cluster.
Workspace setup usually requires about 5 different steps. 

- Ensure the cluster can easily be accessed from a local computer.
- Enable command shortcuts through aliases.
- Setup a GitHub access token for pulling software in from private repositories
  (skip if not needed).
- Create a space on a project drive for where R packages should be installed.
- Install _R_ packages!

## Secure Shell (SSH) Setup

For accessing a cluster from command line, **Secure Shell (SSH)** is preferred.
Access to the cluster requires typing out each time:

```bash
ssh netid@cc-login.campuscluster.illinois.edu
# password
```

Connecting in this manner is tedious since it involves repetitively typing out login credentials.
There are two tricks that void the necessity to do so. Effectively, we have:

- Passwordless login
    - Public/Private SSH Keys
- Alias connection names 
    - SSH Config

Thus, instead of entering a password, the local computer can submit a private key
to be verified by a server. Not only is this more secure, but it avoids the
hassle of remembering the password and typing it out while observers watch. 
Secondly, the connection alias will allow for typing:

```bash
ssh icc
``` 

Not bad eh?

### Generating an SSH Key

On your **local** computer, open up Terminal and type:

```bash
## Run:
ssh-keygen -t rsa -C "netid@illinois.edu"
## Respond to:
# Enter file in which to save the key (/home/demo/.ssh/id_rsa): # [Press enter]
# Enter passphrase (empty for no passphrase): # Write short password
```

### Copy SSH Key to Server

Next, let's copy the generated key from your **local** computer onto the cluster.

```bash
## Run:
ssh-copy-id netid@cc-login.campuscluster.illinois.edu
```

On macOS, prior to using `ssh-copy-id`, the command will need to be installed.
[`Homebrew`](https://brew.sh/) provides a formula that will setup the command.
Install using:

```bash
# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Install the required command binary
brew install ssh-copy-id
```

### SSH Config File

Inside of `~/.ssh/config`, add the following host configuration. Make sure
to **replace** `<netid>` value with your personal netid.

```bash
Host icc
    HostName cc-login.campuscluster.illinois.edu
    User netid
```

**Note:** This assumes a default location is used for the SSH key. If there is
a custom SSH key location add `IdentityFile ~/.ssh/sshkeyname.key`
after the `User` line.

## Bash Aliases

Bash has the ability to create command aliases through `alias`. The primary use
is to take long commands and create short-cuts to avoid typing them. Alternatively,
this allows one to also rename commonly used commands. For example, one could
modify the `ls` command to always list each file and show all hidden files with:

```bash
alias ls='ls -la'` .
```

We suggest creating a `~/.bash_aliases` on the cluster and filling it with:

```bash
--8<-- "config/.bash_aliases"
```

You may download this directly onto the cluster using:

```bash
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/config/.bash_aliases
```

To ensure bash aliases are available, we need to add the file to `~/.bashrc`:

```bash
--8<-- "config/.bashrc"
```

**Note:** the load modules component is shown

You may download this directly onto the cluster using:

```bash
rm -rf ~/.bashrc
wget https://raw.githubusercontent.com/coatless/hpc/master/docs/config/.bashrc
```

## Optional: GitHub Personal Access Token (PAT)

We briefly summarize the process for getting and registering a
[GitHub Personal Access Token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) in _R_.

[![PAT Token Walkthrough Video](http://img.youtube.com/vi/c14aqVC-Szo/0.jpg)](http://www.youtube.com/watch?v=c14aqVC-Szo "Creating a GitHub PAT Token")

The token may be created at: <https://github.com/settings/tokens>

From there, we can add it to the _R_ session with:

```bash
touch ~/.Renviron
cat << EOF >> ~/.Renviron
GITHUB_TOKEN="your_github_token_here"
GITHUB_PAT="your_github_token_here"
EOF
```

Alternatively, within _R_, the token can be added by typing:

```r
file.edit("~/.Renviron")
```

Then, writing in the configuration file:

```bash
GITHUB_TOKEN="your_github_token_here"
GITHUB_PAT="your_github_token_here"
```

## Default _R_ Package Storage Location

_R_'s default library directory where packages are installed into is
found within the user's home directory at:

```bash
# location for R 3.6.z
/home/$USER/R/x86_64-pc-linux-gnu-library/3.6

# location for R 4.0.z
/home/$USER/R/x86_64-pc-linux-gnu-library/4.0
```

Installing packages into the default location is problematic because any
files placed within a user's home directory count against the directories
space quota (~2Gb / 4Gb). As _R_ packages can take a considerable amount of
space when installed, the best course of action is to change the default
library directory. Therefore, _R_ packages should be either stored in a
project directory or a purchased space allocation on the cluster that an
investor may purchase.

The path to an investor's space is given as:

```bash
/projects/<investor>/shared/$USER
```

Frequently, the cluster staff will create a symlink into the investor's
directory once authorization is given. In the case of **Statistics**, the
investor name is `stat`, so the directory would be either:

```bash
/projects/stat/shared/$USER
# or the symlink version:
~/project-stat/
```

In any case, we recommend creating and registering an `r-pkgs` directory
under the appropriate project space. The registration with _R_ is done using
the [`R_LIBS_USER` variable](https://stat.ethz.ch/R-manual/R-patched/library/base/html/libPaths.html) in [`~/.Renvion`](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html).

```bash
# Setup the .Renviron file in the home directory
touch ~/.Renviron

# Append a single variable into the Renvironment file
cat << 'EOF' >> ~/.Renviron
# Location to R library
R_LIBS_USER=~/project-stat/R/%p-library/%v
EOF

# Construct the path
Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
```

Under this approach, we have move the location of the default package directory to:

```
~/project-stat/R/%p-library/%v
# the expanded version of %p and %v give:
~/project-stat/R/x86_64-pc-linux-gnu-library/x.y
```

**Note:** After each minor _R_ version upgrade of R x.y, you will need to
recreate the package storage directory using:

```r
Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
```

One question that arises:

> Why not set up a generic personal library directory called `~/Rlibs`?

We avoided a generic name for two reasons:

1. New "major" releases of _R_ -- and sometime minor versions --
   are incompatible with the old packages.
2. Versioning by number allows for graceful downgrades if needed.

In the case of the first bullet, its better to start over from a new directory
to ensure clean builds.

Though, you could opt not to and remember:

```r
update.packages(ask = FALSE, checkBuilt = TRUE)
```

## Install _R_ packages into library

Prior to installing an _R_ package, make sure to load the appropriate _R_ version
with:

```r
module load R/x.y.z
```

where `x.y.z` is a supported version number, e.g. `module load R/3.6.2` will
make available _R_ 3.6.2.

Once _R_ is loaded, packages can be installed by entering into _R_ or directly
from bash. The prior approach will be preferred as it mimics local _R_ installation
procedures while the latter approach is useful for one-off packages installations.

Enter into an interactive _R_ session from bash by typing:

```bash
R
```

Then, inside of _R_, the package installation may be done using:

```r
# Install a package
install.packages('remotes', repos = 'https://cloud.r-project.org')

# Exit out of R and return to bash.
q(save = "no")
```

Unlike the native _R_ installation route, installing packages under bash uses
the `Rscript` command and requires writing the install command as a string:

```bash
Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
```

Be careful when using quotations to specify packages. For each of these commands,
we begin and end with `"` and, thus, inside the command we use `'` to denote
strings. With this approach, escaping character strings is avoided.


### Installing Packages into Development Libraries

If you need to use a different library path than what was
setup as the default, e.g. `~/project-stat/r-libs`, first create the
directory and, then, specify a path to it with `lib = ''` in `install.packages().

```bash
mkdir -p ~/project-stat/devel-pkg
Rscript -e "install.packages('remotes', lib = '~/project-stat/devel-pkg',
                             repos = 'https://cloud.r-project.org/')"
```

### Installing Packages from GitHub

For packages stored on GitHub, there are two variants for installation depending
on the state of the repository. If the repository is **public**, then the
standard `install_github("user/repo")` may be used. On the other hand, if
the repository is **private**, the package installation call must be accompanied
by a  **[GitHub Personal Access Token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)** in the `auth_token=''` parameter of
`install_github()`. In the prior step, if the `~/.Renviron` contains `GITHUB_PAT`
variable, there is no need to specify in the `install_github()` call as it will
automatically be picked up.

```
# Install package from GitHub
Rscript -e "remotes::install_github('coatless/visualize')"

# Install from a private repository on GitHub
Rscript -e "remotes::install_github('stat385/netid',
                                     auth_token = 'abc')"
```

### Parallelized package installation

By default, all users are placed onto the login nodes. Login nodes are configured
for staging and submitting jobs _not_ for installing software. The best practice and
absolute fastest way to install software is to use an **interactive job**.
Interactive jobs place the user directly on a compute node with the
requested resources, e.g. 10 CPUs or 5GB of memory per CPU.

Before installing multiple _R_ packages, we recommend creating an interactive
job with:

```bash
srun --cpus-per-task=10 --pty bash
```

Once on the interactive node, load the appropriate version of _R_:

```r
module load R/x.y.z # where x.y.z is the version number
```

From here, make sure every package installation call uses the `Ncpus =` parameter
set equal to  the number of cores requested for the interactive job.

```r
Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org', Ncpus = 10L)"
```

