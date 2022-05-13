#!/bin/bash

cd $1
make run gui=1 vsim/dofile=software.tcl vsim/fast_preload=1
cd ..
