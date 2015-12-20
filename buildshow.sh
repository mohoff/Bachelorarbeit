#!/bin/bash

#################################################
# Script to build latex and bibtex files to pdf #
#################################################

# Check for one input parameter specifying file or filename of .tex and .bib file
if [ $# -eq 0 ]
  then
		echo "ERROR: Please provide input file or filename as parameter"
		exit
fi

# Check for mandatory packages to build pdf
NEEDED="texlive texlive-lang-german texlive-bibtex-extra"
printf "\n"
for pkg in $NEEDED; do
  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
    echo -e "CHECK: $pkg is already installed"
  else
    echo -e "ERROR: $pkg not installed. Install it manually in order to continue."
    exit 1;
  fi
done
printf "\n"

#command -v pdflatex >/dev/null 2>&1 || { echo >&2 "pdflatex is not installed. Exiting..."; exit 1; }
#command -v bibtex >/dev/null 2>&1 || { echo >&2 "bibtex is not installed. Exiting..."; exit 1; }

file="$1"
filename="${file%%.*}"

# Proper order for building pdf with bibliography.
# Only display output of last build
{
  pdflatex "$filename"
  bibtex "$filename"
  pdflatex "$filename"
} &> /dev/null
pdflatex "$filename"
printf "\n"

# Move all output files in an output directory. Keep copy of output pdf.
mkdir -p output
mv *.log *.aux *.bbl *.blg *.lof *.lot *.toc output/
cp "$filename".pdf output/

# Open output pdf with system's default pdf viewer.
# Supress output of default pdf viewer, so latex build logs are visible on the console
{
	gnome-open "$filename.pdf"
} &> /dev/null
exit
