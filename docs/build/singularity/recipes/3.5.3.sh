#!/bin/bash

# Setup variables
SOFTWARE_NAME="singularity"
SOFTWARE_VERSION_NUMBER=3.5.3
SOFTWARE_VERSION="${SOFTWARE_NAME}_${SOFTWARE_VERSION_NUMBER//./_}"
SOFTWARE_DIR=~/project-stat/software/${SOFTWARE_NAME}/$SOFTWARE_VERSION_NUMBER
SOFTWARE_TAR=$SOFTWARE_VERSION.tar.gz
SOFTWARE_DL_DIR=~/project-stat/tmp
SOFTWARE_URL=https://github.com/hpcng/singularity/releases/download/v$SOFTWARE_VERSION_NUMBER/singularity-$SOFTWARE_VERSION_NUMBER.tar.gz

# Construct a temporary directory
mkdir -p $SOFTWARE_DL_DIR
cd $SOFTWARE_DL_DIR

# Download software
wget -c $SOFTWARE_URL -O $SOFTWARE_TAR

# Extract software
tar -xzf $SOFTWARE_TAR && cd singularity

# Create a space for it to be stored
mkdir -p $SOFTWARE_DIR

# Run a non-root configuration
# Details:
# https://github.com/hpcng/singularity/issues/4865#issuecomment-568651160
# https://sylabs.io/guides/3.5/admin-guide/installation.html#unprivileged-non-setuid-installation
# https://sylabs.io/guides/3.5/admin-guide/user_namespace.html#userns-requirements
./mconfig --without-suid --prefix=${SOFTWARE_DIR} && \
make -C ./ && \
make -C ./ install

## Have root access?
## Consider using
# ./configure --prefix=/usr/local
# make
# sudo make install


# Step out of the download location
cd ~/

# Remove the temporary directory
rm -rf $SOFTWARE_DL_DIR
