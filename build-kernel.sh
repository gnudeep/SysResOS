#!/bin/bash
# build the object file.
riscv64-unknown-elf-as boot.S -o kernel.o
# Build the ELF file form the object file.
riscv64-unknown-elf-ld -T kernel.lds -o kernel.elf kernel.o
# Build the flat bianry file form the ELF file
riscv64-unknown-elf-objcopy kernel.elf -O binary kernel.bin
