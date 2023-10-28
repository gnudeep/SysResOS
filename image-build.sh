#!/bin/bash

mkimage -f vf2-fit.its -A riscv -O u-boot -T firmware kernel.img
