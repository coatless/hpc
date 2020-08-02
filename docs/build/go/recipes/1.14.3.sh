#!/bin/bash

# Setup variables
SOFTWARE_NAME="go"
SOFTWARE_VERSION_NUMBER=1.14.3
SOFTWARE_VERSION="${SOFTWARE_NAME}_${SOFTWARE_VERSION_NUMBER//./_}"
SOFTWARE_DIR=~/project-stat/software/${SOFTWARE_NAME}/$SOFTWARE_VERSION_NUMBER
SOFTWARE_TAR=$SOFTWARE_VERSION.tar.gz
SOFTWARE_DL_DIR=~/project-stat/tmp
SOFTWARE_URL=https://dl.google.com/go/go$SOFTWARE_VERSION_NUMBER.linux-amd64.tar.gz

# Construct a temporary directory
mkdir -p $SOFTWARE_DL_DIR
cd $SOFTWARE_DL_DIR

# Download software
wget -c $SOFTWARE_URL -O $SOFTWARE_TAR

# Construct a home for software
mkdir -p $SOFTWARE_DIR

# Extract software
tar -xzf $SOFTWARE_TAR --strip-components 1 -C ${SOFTWARE_DIR}

# Step out of the download location
cd ~/

# Remove the temporary directory
rm -rf $SOFTWARE_DL_DIR
