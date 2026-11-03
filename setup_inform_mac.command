#!/bin/bash
# Builds InForm-PE. Any make targets or variables given are passed on to make.
#   --rebuild, -r   delete the built programs first, then build everything again
cd "$(dirname "$0")"

args=()
for arg in "$@"; do
    case "$arg" in
        --rebuild|-r) args+=("rebuild") ;;
        *) args+=("$arg") ;;
    esac
done

make -f inform.mk "${args[@]}"
