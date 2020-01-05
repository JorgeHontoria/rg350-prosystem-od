#!/bin/bash

export PATH=$PATH:/opt/gcw0-toolchain/usr/bin/

make -f Makefile.gcw0 clean
rm build/rg350-prosystem-od.dge
rm build/rg350-prosystem-od.opk
