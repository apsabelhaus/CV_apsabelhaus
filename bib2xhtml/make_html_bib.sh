#!/bin/bash
# a script to run bib2xhtml more easily.

echo "Update this bash script to take in name of file."
DATESTRING=$(date +"%Y-%m-%d")

perl bib2xhtml.pl -c -r -R -n Sabelhaus -s plain bib_files/my_publications_2017-03-18.bib output_html/mypubs_$DATESTRING.html
