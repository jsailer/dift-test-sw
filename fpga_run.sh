#!/bin/bash

$RISCV/bin/riscv32-unknown-elf-gdb -ex "target remote :3333" -ex load -ex s ${1%/}/build/pulpissimo/${1%/}-app//${1%/}-app
