#!/bin/bash
# InForm for QB64-PE Setup script

cd "$(dirname "$0")"

echo "Compiling InForm..."
make clean OS=lnx
make OS=lnx
