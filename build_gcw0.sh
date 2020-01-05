#!/bin/bash

export PATH=$PATH:/opt/gcw0-toolchain/usr/bin/

make -f Makefile.gcw0
mv rg350-prosystem-od.dge build/;
mksquashfs ./build/* ./build/rg350-prosystem-od.opk -all-root -noappend -no-exports -no-xattrs;
