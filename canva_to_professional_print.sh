#!/bin/bash
# https://www.wir-machen-druck.de/tpl/manns-partner/media/ddb/druckdatenskizzen/0/brosch__re_mit_drahtheftung__endformat_quadrat_14_8_cm_x_14_8_cm__28-seitig_2.pdf
infile="$1"
outfile="$2"

temp_file="$1-single.pdf"

mutool poster -x 2 "$infile" "$temp_file"

pdfjam --papersize '{154mm,154mm}' "$temp_file" 1-3,28,27,4-5,26,25,6-7,24,23,8-9,22,21,10-11,20,19,12-13,18,17,14-15,16 -o "$outfile"
