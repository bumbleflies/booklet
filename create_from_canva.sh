#!/bin/bash

infile="$1"
outfile="$2"

temp_file="$1-single.pdf"

mutool poster -x 2 "$infile" "$temp_file"

pdfjam --papersize '{148mm,148mm}' "$temp_file" 1-3,28,27,4-5,26,25,6-7,24,23,8-9,22,21,10-11,20,19,12-13,18,17,14-15,16 -o "$outfile"
