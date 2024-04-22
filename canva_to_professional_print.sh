#!/bin/bash
# https://www.wir-machen-druck.de/tpl/manns-partner/media/ddb/druckdatenskizzen/0/brosch__re_mit_drahtheftung__endformat_quadrat_14_8_cm_x_14_8_cm__28-seitig_2.pdf

# Exported PDF is
# Paper size: 308 × 160 mm
# Page size:  873.266 x 454.016 pts
#
# required output
# Paper size print: 154 x 154 mm
# Paper size: 436.633 x 436.633 pts
# Content size print: 148 x 148 mm
# Paper size: 420 x 420 pts

infile="$1"
outfile="$2"

tempfile=$(mktemp --suffix=.pdf)
left_pages=$(mktemp --suffix=.pdf)
right_pages=$(mktemp --suffix=.pdf)

echo -n "extracting left pages..."
pdfcrop --margins "-9.37200000000002 -9.18350000000002 -428.995 -9.18350000000002" $infile $left_pages > /dev/null
echo "done."

echo -n "extracting right pages..."
pdfcrop --margins "-428.995 -9.18350000000002 -9.37200000000002 -9.18350000000002" $infile $right_pages > /dev/null
echo "done."

echo -n "assembling final booklet..."
pdfjam --papersize '{154mm,154mm}' $left_pages $right_pages -o $tempfile > /dev/null 2>&1
pdfjam --papersize '{154mm,154mm}' $tempfile '15,2,16,3,17,4,18,5,19,6,20,7,21,8,22,9,23,10,24,11,25,12,26,13,27,14,28,1' -o $outfile > /dev/null 2>&1
echo "done."
