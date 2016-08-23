#!/bin/bash
#
# University of Puget Sound
# Writer's Handbook
#
# Paths
declare REPOS=/Your/Path/Here
# `Repos` should be the path to a directory that contains both `mathbook` and `writershandbook`
declare MB=${REPOS}/mathbook
declare MBXSL=${MB}/xsl
declare MBUSER=${MB}/user
declare HANDBOOK=${REPOS}/writershandbook
declare SOURCE=${HANDBOOK}/src
declare IMAGES=${HANDBOOK}/images
declare OUTPUT=${HANDBOOK}/output
#
# MathBook XML, dev branch of *public* repository
echo
echo "BUILD: Update MathBook XML :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${MB}
git checkout handbook
git pull
#
# `ups-writers` in `mathbook/contrib`
echo
echo "BUILD: Update Custom XML :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp ${MB}/contrib/ups-writers/ups-writers-html.xsl ${MBUSER}/ups-writers-html.xsl
cp ${MB}/contrib/ups-writers/ups-writers-latex.xsl ${MBUSER}/ups-writers-latex.xsl
#
# Clear Old Output
echo
echo "BUILD: Clearing Old Output :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${HANDBOOK}
rm -rfv ${OUTPUT}
mkdir ${OUTPUT}
cd ${OUTPUT}
mkdir images
#
# Create Images
echo
echo "BUILD: Collecting Images :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${IMAGES}
cp -a ${IMAGES}/. ${OUTPUT}/images/
cd ${OUTPUT}/images/
#
# Create SVGs
echo
echo "BUILD: Creating SVG Images :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
for FILE in ./*.pdf; do
  pdf2svg "${FILE}" "${FILE%.pdf}".svg
done
#
# Create YouTube Thumbnails
echo
echo "BUILD: Creating YouTube Thumbnails :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${OUTPUT}/images
python3 ${MB}/script/mbx --component youtube --directory ${OUTPUT}/images ${SOURCE}/WritersHandbook.mbx
#
# Build the HTML Version
echo
echo "BUILD: Building HTML Version :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${OUTPUT}
xsltproc --xinclude ${MBUSER}/ups-writers-html.xsl ${SOURCE}/WritersHandbook.mbx
#
# Build Default LaTeX Version
echo
echo "BUILD: Building Default LaTeX Version :BUILD"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cd ${OUTPUT}
xsltproc --xinclude ${MBUSER}/ups-writers-latex.xsl ${SOURCE}/WritersHandbook.mbx
latexmk --f --latex=xelatex --xelatex WritersHandbook.tex
