#!/bin/bash

# Setup variables
PANDOC_VERSION_NUMBER=2.9.2.1
PANDOC_VERSION="pandoc_${PANDOC_VERSION_NUMBER//./_}"
PANDOC_DIR=~/project-stat/software/pandoc/$PANDOC_VERSION_NUMBER
PANDOC_TAR=$PANDOC_VERSION.tar.bz2
PANDOC_DL_DIR=~/project-stat/tmp
PANDOC_URL=https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION_NUMBER/pandoc-$PANDOC_VERSION_NUMBER-linux-amd64.tar.gz

# Construct a temporary directory
mkdir -p $PANDOC_DL_DIR
cd $PANDOC_DL_DIR

# Download pandoc
wget -c $PANDOC_URL -O $PANDOC_TAR

# Setup software directory
mkdir -p $PANDOC_DIR

# Unpack into $PANDOC_DIR/bin
tar xvzf $PANDOC_TAR --strip-components 1 -C $PANDOC_DIR

# Step out of the download location
cd ~/

# Remove the temporary directory
rm -rf $PANDOC_DL_DIR
