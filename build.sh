#!/bin/bash

# Build the bood loader object file.
riscv64-unknown-elf-as boot.S -o kernel.o
# Build the ELF file according to the load script or the linker file.
riscv64-unknown-elf-ld -T kernel.lds -o kernel.elf kernel.o

