#!/bin/bash
#
# University of Puget Sound
# Writer's Handbook

# Be sure to make this file executable, and run with path
# i.e.  $ chmod 700 build.sh
# e.g.  [soundwriting/script] $ ./build.sh

# Source a custom file with three path names
# See paths.sh.template, copy to paths.sh and edit
# "dot" syntax is POSIX for "source"
# Alternatives: http://stackoverflow.com/questions/192292
DIR="$(dirname "$0")"
. ${DIR}/paths.sh

# following depend on paths source'd above
declare SWXSL=${SRC}/xsl
declare MBUSER=${MBX}/user
declare MBXSCRIPT=${MBX}/script/mbx
declare SOURCE=${SRC}/src
declare IMAGES=${SOURCE}/images
declare CSS=${SRC}/css
declare ASSETS=${SRC}/assets


# convenience for rsync command, hopefully not OS dependent
# INCLUDES  --delete  switch at end.
# This is an *exact* mirror of HTML build directory
# If we want PDFs posted, potentially place
declare RSYNC="rsync --verbose  --progress --stats --compress --rsh=/usr/bin/ssh --recursive --delete"

# website upload parameterized by username
declare UNAME="$2"

# useful date string
# http://stackoverflow.com/questions/1401482
declare DATE=`date +%Y-%m-%d`


# Common setup
function setup {
    # Always place/update `ups-writers` in "user" XSL directory
    echo
    echo "BUILD: Update Custom XSL :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${MBUSER}
    cp ${SWXSL}/ups-writers-html.xsl    ${MBUSER}/ups-writers-html.xsl
    cp ${SWXSL}/ups-writers-latex.xsl   ${MBUSER}/ups-writers-latex.xsl
    cp ${SWXSL}/ups-writers-latex-styled.xsl   ${MBUSER}/ups-writers-latex-styled.xsl
}

function build_you_tube_thumbnail {
    echo
    echo "BUILD: Building YouTube Thumbnails :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ${MBXSCRIPT} -c youtube -d ${IMAGES} ${SOURCE}/SoundWriting.ptx
}

# Validation using RELAX-NG
# Colors, 3 other elements, and one attribute,
# are all non-standard extensions
function schema-validate {
    echo
    echo "BUILD: RELAX-NG Validation :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}
    java\
        -classpath ${JINGTRANG}\
        -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration\
        -jar ${JINGTRANG}/jing.jar\
        ${MBX}/schema/pretext.rng ${SOURCE}/SoundWriting.ptx\
    | grep -v\
        -e ': error: element "blue" not allowed anywhere;'\
        -e ': error: element "darkgreen" not allowed anywhere;'\
        -e ': error: element "darkpurple" not allowed anywhere;'\
        -e ': error: element "darkred" not allowed anywhere;'\
        -e ': error: element "gray" not allowed anywhere;'\
        -e ': error: element "green" not allowed anywhere;'\
        -e ': error: element "lightblue" not allowed anywhere;'\
        -e ': error: element "lightgreen" not allowed anywhere;'\
        -e ': error: element "lightpink" not allowed anywhere;'\
        -e ': error: element "lightpurple" not allowed anywhere;'\
        -e ': error: element "maroon" not allowed anywhere;'\
        -e ': error: element "navy" not allowed anywhere;'\
        -e ': error: element "orange" not allowed anywhere;'\
        -e ': error: element "pink" not allowed anywhere;'\
        -e ': error: element "purple" not allowed anywhere;'\
        -e ': error: element "red" not allowed anywhere;'\
        -e ': error: element "teal" not allowed anywhere;'\
        -e ': error: element "i" not allowed anywhere;'\
        -e ': error: element "un" not allowed anywhere;'\
        -e ': error: element "highlight" not allowed anywhere;'\
        -e ': error: found attribute "link", but no attributes allowed here'\
        -e ': error: attribute "indent" not allowed here;'\
    > ${SCRATCH}/errors.txt
    echo
    echo "BUILD: Schematron Validation :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    xsltproc --xinclude ${MBX}/schema/pretext-schematron.xsl ${SOURCE}/SoundWriting.ptx\
    >> ${SCRATCH}/errors.txt
}

function view_errors {
    Less ${SCRATCH}/errors.txt
}

# Subroutine to build the Puget Sound HTML version
function build_htmlups {
    echo
    echo "BUILD: Building Puget Sound HTML Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # create directory, and cleanout previous runs
    install -d ${SCRATCH}/htmlups
    rm ${SCRATCH}/htmlups/*.html ${SCRATCH}/htmlups/*.js ${SCRATCH}/htmlups/knowl/*  ${SCRATCH}/htmlups/images/*
    ${MBX}/pretext/pretext -vv -c all -f html -X ${MBUSER}/ups-writers-html.xsl -p ${SOURCE}/publication-pugetsound.xml -d ${SCRATCH}/htmlups ${SOURCE}/SoundWriting.ptx
}

function view_htmlups {
    ${HTMLVIEWER} ${SCRATCH}/htmlups/index.html
}

# Subroutine to build the Universal HTML version
function build_htmluniversal {
    echo
    echo "BUILD: Building Universal HTML Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # create directory, and cleanout previous runs
    install -d ${SCRATCH}/htmluniversal
    rm ${SCRATCH}/htmluniversal/*.html ${SCRATCH}/htmluniversal/*.js ${SCRATCH}/htmluniversal/knowl/*  ${SCRATCH}/htmluniversal/images/* 
    ${MBX}/pretext/pretext -vv -c all -f html -X ${MBUSER}/ups-writers-html.xsl -p ${SOURCE}/publication-pugetsound.xml -d ${SCRATCH}/htmluniversal ${SOURCE}/SoundWriting.ptx
}

function view_htmluniversal {
    ${HTMLVIEWER} ${SCRATCH}/htmluniversal/index.html
}

# Subroutine to build the electronic PDF version, styled in color
function build_pdfups {
    echo
    echo "BUILD: Building UPS PDF Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH} # Create the scratch directory
    ${MBX}/pretext/pretext -vv -c all -f pdf -X ${MBUSER}/ups-writers-latex-styled.xsl -p ${SOURCE}/publication-pugetsound.xml -o ${SCRATCH}/soundwriting-${DATE}-pugetsound.pdf ${SOURCE}/SoundWriting.ptx
}

function view_pdfups {
    ${PDFVIEWER} ${SCRATCH}/soundwriting-${DATE}-pugetsound.pdf &
}

# Subroutine to build the electronic PDF version
function build_pdfuniversal {
    echo
    echo "BUILD: Building Universal PDF Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH} # Create the scratch directory
    ${MBX}/pretext/pretext -vv -c all -f pdf -X ${MBUSER}/ups-writers-latex-styled.xsl -p ${SOURCE}/publication-universal.xml -o ${SCRATCH}/soundwriting-${DATE}-universal.pdf ${SOURCE}/SoundWriting.ptx
}

function view_pdfuniversal {
    ${PDFVIEWER} ${SCRATCH}/soundwriting-${DATE}-universal.pdf &
}

# Subroutine to build the print PDF version
# Use of deprecated string parameter is a small
# hack to avoid creating an entirely new publication
# file for just this one difference. (2023-01-12)
function build_print {
    install -d ${SCRATCH} # Create the scratch directory
    ${MBX}/pretext/pretext -vv -c all -f pdf -x latex.print yes -X ${MBUSER}/ups-writers-latex-styled.xsl -p ${SOURCE}/publication-pugetsound.xml -o ${SCRATCH}/soundwriting-${DATE}-print.pdf ${SOURCE}/SoundWriting.ptx
}

function view_print {
    ${PDFVIEWER} ${SCRATCH}/soundwriting-${DATE}-print.pdf &
}

# Check to make sure we have a username
function website_valid {
    # test for zero string as account name and exit with message
    if [ -z "${UNAME}" ] ; then
        echo
        echo "BUILD: Website upload needs an account username, quitting... :BUILD"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        exit
    fi
    echo
}

# $2 (aliased to ${UNAME}) is a username with priviliges at
# /var/www/html/soundwriting.pugetsound.edu/ on userweb.pugetsound.edu
function website {
    echo "BUILD: rsync entire web version...                      :BUILD"
    echo "BUILD: username as parameter 2, then supply password... :BUILD"
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    cp ${ASSETS}/*.html ${SCRATCH}/html/ # Used by Google to confirm site ownership.
    ${RSYNC} ${SCRATCH}/html/*  ${UNAME}@userweb.pugetsound.edu:/var/www/html/soundwriting.pugetsound.edu
}

# Main command-line interpreter
case "$1" in
    "all")
    setup
    build_htmlups
    build_htmluniversal
    build_pdfups
    build_pdfuniversal
    build_print
    ;;
    "youtube")
    build_you_tube_thumbnail
    ;;
    "htmlups")
    setup
    build_htmlups
    ;;
    "viewhtmlups")
    view_htmlups
    ;;
    "htmluniversal")
    setup
    build_htmluniversal
    ;;
    "viewhtmluniversal")
    view_htmluniversal
    ;;
    "pdfuniversal")
    setup
    build_pdfuniversal
    ;;
    "viewpdfuniversal")
    view_pdfuniversal
    ;;
    "pdfups")
    setup
    build_pdfups
    ;;
    "viewpdfups")
    view_pdfups
    ;;
    "print")
    setup
    build_print
    ;;
    "viewprint")
    view_print
    ;;
    "validate")
    setup
    schema-validate
    ;;
    "viewerrors")
    setup
    view_errors
    ;;
    "website")
    website_valid
    setup
    build_html
    website
    ;;
    *)
    echo "Supply an option: all|youtube|htmlups|viewhtmlups|htmluniversal|viewhtmluniversal|pdfuniversal|viewpdfuniversal|pdfups|viewpdfups|print|viewprint|validate|viewerrors|website <username>"
    ;;
esac
