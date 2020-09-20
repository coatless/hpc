# Cluster Setup

Within this chapter, we will cover establishing a workspace on the Campus Cluster.
There are about four different configuration steps.

- Ensure the cluster can easily be accessed from a local computer.
- Create a space on a project drive for where R packages should be installed.
- Setup a GitHub access token for pulling software in from private repositories (skip if not needed).
- Install _R_ packages!

## SSH

Repetitively typing out login credentials is tedious:

```bash
ssh netid@cc-login.campuscluster.illinois.edu
# password
```

There are two tricks that void the necessity to do so. Effectively, we have:

- Public/Private SSH Keys
    - Passwordless login
- SSH Config
    - Alias connection names

Thus, instead of entering a password, the local computer can submit a private key
to be verified by a server. Not only is this more secure, but it avoids the
hassle of constantly typing passwords. Secondly, the connection alias will
allow for typing `ssh icc` instead of `ssh netid@cc-login.campuscluster.illinois.edu`

#### Generating an SSH Key

On your **local** computer, open up Terminal and type:

```bash
## Run:
ssh-keygen -t rsa -C "netid@illinois.edu"
## Respond to:
# Enter file in which to save the key (/home/demo/.ssh/id_rsa): # [Press enter]
# Enter passphrase (empty for no passphrase): # Write short password
```

#### Copy SSH Key to Server

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

#### Setting up a Configuration

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

## Setup R

### Create library

```bash
mkdir ~/project-stat/r-pkgs

cat << 'EOF' >> ~/.bashrc
  if [ -n $R_LIBS ]; then
      export R_LIBS=~/project-stat/r-pkgs:$R_LIBS
  else
      export R_LIBS=~/project-stat/r-pkgs
  fi
EOF
```

### Setup a GitHub Personal Access Token (PAT)

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

### Install *R* packages into library

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


#### Installing Packages into Development Libraries

If you need to use a different library path than what was
setup as the default, e.g. `~/project-stat/r-libs`, first create the
directory and, then, specify a path to it with `lib = ''` in `install.packages().

```bash
mkdir -p ~/project-stat/devel-pkg
Rscript -e "install.packages('remotes', lib = '~/project-stat/devel-pkg',
                             repos = 'https://cloud.r-project.org/')"
```

#### Installing Packages from GitHub

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

