#!/bin/bash
# https://www.wir-machen-druck.de/tpl/manns-partner/media/ddb/druckdatenskizzen/0/brosch__re_mit_drahtheftung__endformat_quadrat_14_8_cm_x_14_8_cm__28-seitig_2.pdf
infile="$1"
outfile="$2"

tempfile=$(mktemp --suffix=.pdf)
left_pages=$(mktemp --suffix=.pdf)
right_pages=$(mktemp --suffix=.pdf)

echo -n "extracting left pages..."
pdfcrop --margins "0 0 -420 0" $infile $tempfile > /dev/null
pdfcrop --margins "-18" $tempfile $left_pages > /dev/null
echo "done."

echo -n "extracting right pages..."
pdfcrop --margins "-420 0 0 0" $infile $tempfile > /dev/null
pdfcrop --margins "-18" $tempfile $right_pages > /dev/null
echo "done."

echo -n "assembling final booklet..."
pdfjam --papersize '{154mm,154mm}' $left_pages $right_pages -o $tempfile > /dev/null 2>&1
pdfjam --papersize '{154mm,154mm}' $tempfile '15,2,16,3,17,4,18,5,19,6,20,7,21,8,22,9,23,10,24,11,25,12,26,13,27,14,28,1' -o $outfile > /dev/null 2>&1
echo "done."
