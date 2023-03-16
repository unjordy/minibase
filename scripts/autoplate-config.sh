#!/usr/bin/env bash

shopt -s globstar

rm -f out/.autoplate.ini

for stl_file in out/**/*.stl; do
    echo "[$stl_file]" >> out/.autoplate.ini
    prusa-slicer --info $stl_file | tail -n +2 >> out/.autoplate.ini
done
