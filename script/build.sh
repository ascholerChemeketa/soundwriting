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
declare MBXSL=${MBX}/xsl
declare MBUSER=${MBX}/user
declare SOURCE=${SRC}/src
declare IMAGES=${SRC}/images

# convenience for rsync command, hopefully not OS dependent
# DOES NOT includes  --delete  switch at end due to PDF in directory
# If switch is included this could be an *exact* mirror of build directory
declare RSYNC="rsync --verbose  --progress --stats --compress --rsh=/usr/bin/ssh --recursive"

# website upload parameterized by username
declare UNAME="$2"

# Common setup
function setup {
    # not necessary, but always build scratch directory first
    echo
    echo "BUILD: Setup Scratch Directory :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}

    # Always place/update `ups-writers` in `mathbook/contrib`
    echo
    echo "BUILD: Update Custom XML :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${MBUSER}
    cp ${MBX}/contrib/ups-writers/ups-writers-html.xsl ${MBUSER}/ups-writers-html.xsl
    cp ${MBX}/contrib/ups-writers/ups-writers-latex.xsl ${MBUSER}/ups-writers-latex.xsl
}

# Subroutine to build the HTML Version
function html_build {
    echo
    echo "BUILD: Building HTML Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/html ${SCRATCH}/html/images ${SCRATCH}/html/knowl
    cd ${SCRATCH}/html
    rm *.html
    rm -rf knowl/* images/*
    cp -a ${IMAGES}/*.svg ./images/
    xsltproc --xinclude ${MBUSER}/ups-writers-html.xsl ${SOURCE}/WritersHandbook.mbx
}

function view_html {
    ${HTMLVIEWER} ${SCRATCH}/html/index.html
}

# Subroutine to build the PDF/print Version
function pdf_build {
    echo
    echo "BUILD: Building Print Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/pdf ${SCRATCH}/pdf/images
    cd ${SCRATCH}/pdf
    rm WritersHandbook.tex
    cp -a ${IMAGES}/* ./images/
    xsltproc --xinclude ${MBUSER}/ups-writers-latex.xsl ${SOURCE}/WritersHandbook.mbx
    xelatex WritersHandbook.tex
    xelatex WritersHandbook.tex
}

function view_pdf {
    ${PDFVIEWER} ${SCRATCH}/pdf/WritersHandbook.pdf
}

# $2 is a username with priviliges at
# /var/www/html/soundwriting.pugetsound.edu/ on userweb.pugetsound.edu
function website {
    # test for zero string as account name and exit with message
    if [ -z "${UNAME}" ] ; then
        echo
        echo "BUILD: Website upload needs an account username, quitting... :BUILD"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        exit
    fi
    echo
    echo "BUILD: rsync entire web version...                      :BUILD"
    echo "BUILD: username as parameter 2, then supply password... :BUILD"
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # build it first, cleanly
    build_html
    ${RSYNC} ${SCRATCH}/html/*  ${UNAME}@userweb.pugetsound.edu:/var/www/html/soundwriting.pugetsound.edu/beta
}

# Main command-line interpreter
case "$1" in
    "pdf")
    setup
    pdf_build
    ;;
    "html")
    setup
    html_build
    ;;
    "website")
    website
    ;;
    "viewpdf")
    view_pdf
    ;;
    "viewhtml")
    view_html
    ;;
    *)
    echo "Supply an option: pdf|html|website <username>|viewpdf|viewhtml"
    ;;
esac
