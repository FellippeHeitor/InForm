#!/bin/bash
# InForm for QB64-PE Setup script

cd "$(dirname "$0")"

echo "Compiling InForm..."
make -f makefile.inform clean OS=lnx
make -f makefile.inform OS=lnx

if [ -e "./InForm/UiEditor" ]; then
	echo "Adding InForm menu entry..."
	cat > ~/.local/share/applications/qb64-inform.desktop <<EOF
[Desktop Entry]
Name=QB64 InForm GUI Designer
GenericName=QB64 InForm GUI Designer
Exec=$_pwd/InForm/UiEditor
Icon=$_pwd/InForm/resources/InForm.ico
Terminal=false
Type=Application
Categories=Development;IDE;GUI
Path=$_pwd
StartupNotify=false
EOF
	echo "Running InForm Designer..."
	cd InForm
	./UiEditor &
else
	echo "Compilation failed."
	echo "Make sure you unpacked all files in QB64's folder, preserving the directory structure and also that you have the latest version of QB64 to use InForm."
fi  

