# Cluster Setup

## SSH Tricks (Keys & Aliases)

Repetitively typing out login credentials is tedious:

```bash
ssh netid@cc-login.campuscluster.illinois.edu
# password
```

There are two tricks that void this and also make locally
launched script jobs possible.

- Public/Private keys
    - Passwordless login
- SSH Config
    - Alias connection names

Instead of entering a password, the local computer can submit a private key to be
verified by a server. This is a bit more secure and avoids the hassle of constantly
typing passwords.

#### Generating an SSH Key

```bash
## Run:
ssh-keygen -t rsa -C "netid@illinois.edu"
## Respond to:
# Enter file in which to save the key (/home/demo/.ssh/id_rsa): # [Press enter]
# Enter passphrase (empty for no passphrase): # Write short password
```

#### Copy SSH Key to Server

```bash
## Run:
ssh-copy-id netid@cc-login.campuscluster.illinois.edu
```

#### Setting up a Configuration

Add^[**Note:** This assumes a default location is used for the SSH key. If there is a custom SSH key location add `IdentityFile ~/.ssh/sshkeyname.key` after the `User` line.]
the following to `~/.ssh/config`^[**Replace** `netid` with your netid.]

```bash
Host icc
    HostName cc-login.campuscluster.illinois.edu
    User netid
```


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

Alternatively, within _R_, type:

```r
file.edit("~/.Renviron")
```

Then, add: 

```bash
GITHUB_TOKEN="your_github_token_here"
GITHUB_PAT="your_github_token_here"
```

### Install *R* packages into library

```bash
# Installs your R package to default library.  
Rscript -e "install.packages('devtools', repos = 'http://ftp.ussg.iu.edu/CRAN/')"

# Setup a developmental library to install packages to
Rscript -e "install.packages('devtools', lib = '~/project-stat/devel-pkg',
                             repos = 'http://ftp.ussg.iu.edu/CRAN/')"
              
# Install package from GitHub
Rscript -e "remotes::install_github('coatless/visualize')"

# Install from a private repository on GitHub
Rscript -e "remotes::install_github('stat385/netid',
                                    auth_token = 'abc')"
```

Be careful when using quotations to specify packages. For each of these commands,
we begin and end with `"` and, thus, inside the command we use `'` to denote 
strings. With this approach, escaping character strings is avoided.

The `auth_token` requires the use of **[GitHub Personal Access Token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)**.
In the prior step, if the `~/.Renviron` contains the `GITHUB_TOKEN` or `GITHUB_PAT`
variable, there is no need to specify in the `install_*()` call as it will
automatically be picked up.

