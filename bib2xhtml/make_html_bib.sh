#!/bin/bash
# a script to run bib2xhtml more easily.

# First, get a list of options, and change output if needed.
# Set the HELP variable to zero to start with. E.g., default to not outputing help.
HELP=0

# Declare the help message, which will be output in two places:
HELPMESSAGE=$'\nThe make_html_bib.sh script requires one option: the name of the bib file to convert. \nBy default, this assumes the bib file is under ./bib_files/. \n \nOptions: -h, print this help message.'

# Prefix for the file path:
#FILE_PREFIX='bib_files/'
#FILE_PREFIX='.'

while getopts h option
do
    case "${option}"
    in
	h) HELP=1;;
    esac
done

# If help is specified, print a message and exit.
if [ "$HELP" == 1 ]; then
    echo "$HELPMESSAGE"
    echo "Exiting without creating an html file..."
    exit
fi

# Otherwise, check on the number of arguments. Should only be one, if have not exited yet.
if [ $# -eq 0 ]
then
    echo "$HELPMESSAGE"
    echo "Exiting without creating an html file..."
    exit
elif [ $# -eq 1 ]
then
    # Actually create the file.
    DATESTRING=$(date +"%Y-%m-%d")
    #FILE_PATH=./$FILE_PREFIX$1
    FILE_PATH=$1
    FILE_OUTPUT=./output_html/mypubs_$DATESTRING.html
    echo "Creating HTML file from" $FILE_PATH
    perl bib2xhtml.pl -c -r -R -n Sabelhaus -s plain $FILE_PATH $FILE_OUTPUT
    echo "Wrote" $FILE_OUTPUT
    exit
elif [ $# > 2 ]
then
    echo "Script only takes one argument. For help, pass in -h"
    echo "Exiting without creating an html file..."
    exit
fi

