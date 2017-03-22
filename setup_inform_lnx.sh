#!/bin/bash
# InForm for QB64 - Setup script

if [ -e "./qb64" ]; then
  echo "Compiling InForm..."
  ./qb64 -x ./InForm/UiEditor.bas -o ./UiEditor

  if [ -e "./UiEditor" ]; then
      echo "Running InForm Designer..."
      ./UiEditor &
  else
      echo "Compilation failed."
      echo "Make sure you unpacked all files in QB64's folder, preserving the directory structure and also that you have version 1.1 of QB64 to use InForm."
  fi  
else
      echo "Compilation failed."
      echo "Make sure you have version 1.1 of QB64 to use InForm."
fi
echo
echo "Thank you for choosing InForm for QB64."
