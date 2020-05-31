#!/bin/bash

# Setup variables
BOOST_VERSION_NUMBER=1.73.0
BOOST_VERSION="boost_${BOOST_VERSION_NUMBER//./_}"
BOOST_DIR=~/project-stat/software/boost/$BOOST_VERSION_NUMBER
BOOST_TAR=$BOOST_VERSION.tar.bz2
BOOST_DL_DIR=~/project-stat/tmp
BOOST_BUILD_DIR=$BOOST_DL_DIR/boost-build
BOOST_URL=https://dl.bintray.com/boostorg/release/$BOOST_VERSION_NUMBER/source/$BOOST_TAR

# Load modules used to compile boost
module load gcc/7.2.0
module load python/2

# Construct a temporary directory
mkdir -p $BOOST_DL_DIR
cd $BOOST_DL_DIR

# Download boost
wget -c $BOOST_URL -O $BOOST_TAR

# Construct a nested build directory
mkdir -p $BOOST_BUILD_DIR
cd $BOOST_BUILD_DIR

# Unpack boost from downloaded tar
tar --bzip2 -xf ../$BOOST_TAR

# Change to the extracted boost verison folder
cd $BOOST_VERSION

## Boost-specific installation

# Setup boost
./bootstrap.sh --prefix=${BOOST_DIR}

# Create the target directory
mkdir -p $BOOST_DIR

# Compile
./b2 --prefix=${BOOST_DIR} -j 10 install

# Step out of the build location
cd ~/

# Remove the build directory
rm -rf $BOOST_DL_DIR
