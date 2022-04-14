#!/bin/bash

### Create/Update Several Dumps ###
cd $1
mkdir dump -p
make dis > dump/${1%/}-dump.txt
#make dis -disopt="-s -j .data" > dump-data.txt
#make dis -disopt="-S --disassemble" > dump-src.txt
#make dis -disopt="-t" > dump-sym.txt
$RISCV/bin/riscv32-unknown-elf-objdump -s -j .data  build/pulpissimo/${1%/}-app/${1%/}-app > dump/${1%/}-dump-data.txt
$RISCV/bin/riscv32-unknown-elf-objdump -S --disassemble build/pulpissimo/${1%/}-app/${1%/}-app > dump/${1%/}-dump-src.txt
$RISCV/bin/riscv32-unknown-elf-objdump -t build/pulpissimo/${1%/}-app/${1%/}-app > dump/${1%/}-dump-sym.txt
cd ..
