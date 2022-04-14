#!/bin/bash

cd $1
make clean all
cd ..
./dump.sh $1
