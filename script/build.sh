#!/bin/bash
#
# University of Puget Sound
# Writer's Handbook

# Paths, edit these to suit (generalize)
declare MBX=/home/rob/mathbook/mathbook
declare SRC=/home/rob/books/upshb/writershandbook
declare SCRATCH=/tmp/wh

# following depend on above
declare MBXSL=${MBX}/xsl
declare MBUSER=${MBX}/user
declare SOURCE=${SRC}/src
declare IMAGES=${SRC}/images
# `ups-writers` in `mathbook/contrib`
echo
echo "BUILD: Update Custom XML :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
install -d ${MBUSER}
cp ${MBX}/contrib/ups-writers/ups-writers-html.xsl ${MBUSER}/ups-writers-html.xsl
cp ${MBX}/contrib/ups-writers/ups-writers-latex.xsl ${MBUSER}/ups-writers-latex.xsl

# Create directories
echo
echo "BUILD: Setup Scratch Directories :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
install -d ${SCRATCH} ${SCRATCH}/pdf ${SCRATCH}/html ${SCRATCH}/pdf/images ${SCRATCH}/html/images
install -d ${SCRATCH}/pdf ${SCRATCH}/pdf/images
install -d ${SCRATCH}/html ${SCRATCH}/html/images

# Build the PDF/print Version
echo
echo "BUILD: Building Print Version :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${SCRATCH}/pdf
rm WritersHandbook.tex
cp -a ${IMAGES}/* ./images/
xsltproc --xinclude ${MBUSER}/ups-writers-latex.xsl ${SOURCE}/WritersHandbook.mbx
xelatex WritersHandbook.tex
xelatex WritersHandbook.tex
