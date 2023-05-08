# InForm for QB64-PE Setup script

cd "$(dirname "$0")"

echo "Compiling InForm..."
make -f makefile.inform clean OS=osx QB64PE_PATH=../QB64pe/
make -f makefile.inform OS=osx QB64PE_PATH=../QB64pe/
