#!/usr/bin/env bash

shopt -s globstar

for scad_file in **/*.scad; do
    build_ids=$(openscad $scad_file -D scad_build_scan=true -o - --export-format echo | grep -oP 'ECHO: "scad_build_scan: \K[^"]*')
    for build_id in $build_ids; do
        echo "out/$(basename $scad_file .scad)/$build_id.stl"
    done
done
