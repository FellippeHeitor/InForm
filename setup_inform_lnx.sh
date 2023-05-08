#!/bin/bash
# InForm for QB64-PE Setup script

cd "$(dirname "$0")"

echo "Compiling InForm..."
make -f makefile.inform clean OS=lnx QB64PE_PATH=../QB64pe/
make -f makefile.inform OS=lnx QB64PE_PATH=../QB64pe/
