# InForm for QB64-PE Setup script

cd "$(dirname "$0")"

echo "Compiling InForm..."
make clean OS=osx
make OS=osx
