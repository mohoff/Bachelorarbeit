#!/bin/bash
if [ $# -eq 0 ]
  then
		echo "Error: Please provide input file as parameter"
		exit
fi

file="$1"
filename="${file%%.*}"

# Proper order for building pdf with bibliography
{
  pdflatex "$filename"
  bibtex "$filename"
  pdflatex "$filename"
} &> /dev/null
pdflatex "$filename"

# Separate tmp/log output from output pdf
mkdir -p output
mv test.aux output/test.aux
mv test.log output/test.log
cp "$filename".pdf output/"$filename".pdf

# Open output pdf with system's default pdf viewer
# Supress output of default pdf viewer, so latex build logs are visible on the console
{
	gnome-open "$filename.pdf"
} &> /dev/null
exit
