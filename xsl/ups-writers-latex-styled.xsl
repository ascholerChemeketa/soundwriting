<?xml version='1.0'?> <!-- As XML file -->

<!-- For University of Puget Sound, Writer's Handbook      -->
<!-- 2019-10-30  R. Beezer, preliminary styling setup      -->

<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "../xsl/entities.ent">
    %entities;
]>

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Place ups-writers-latex-styled.xsl file into  mathbook/user -->
<!-- Assumes next file can be found in mathbook/user, so it must be copied there -->
<xsl:import href="ups-writers-latex.xsl" />

<xsl:output method="text" />

<!-- ########## -->
<!-- Font Setup -->
<!-- ########## -->

<!-- xelatex as engine, presumes \usepackage{fontspec} -->
<!-- which *is* part of the xelatex-specific part      -->
<!-- Path option value is (Ubuntu) Linux specific      -->
<!-- The oldstyle numbers will be used in page         -->
<!-- headers and footers                               -->
<xsl:param name="latex.preamble.late">
    <!-- <xsl:text>\usepackage[default,regular,black]{sourceserifpro}&#xa;</xsl:text> -->
    <xsl:text>\setmainfont{texgyreschola-regular.otf}[Path=/usr/share/texmf/fonts/opentype/public/tex-gyre/, ItalicFont=texgyreschola-italic.otf,BoldFont=texgyreschola-bold.otf,BoldItalicFont=texgyreschola-bolditalic.otf]&#xa;</xsl:text>
    <xsl:text>\newfontfamily{\divisionheadingfont}{texgyreheros-regular.otf}[Path=/usr/share/texmf/fonts/opentype/public/tex-gyre/,ItalicFont=texgyreheros-italic.otf,BoldFont=texgyreheros-bold.otf,BoldItalicFont=texgyreheros-bolditalic.otf]&#xa;</xsl:text>
    <xsl:text>\newfontfamily{\pageheadingfont}{texgyrepagella-regular.otf}[Numbers=OldStyle,Path=/usr/share/texmf/fonts/opentype/public/tex-gyre/,ItalicFont=texgyrepagella-italic.otf,BoldFont=texgyrepagella-bold.otf,BoldItalicFont=texgyrepagella-bolditalic.otf]&#xa;</xsl:text>
</xsl:param>

<!-- ################# -->
<!-- Division Headings -->
<!-- ################# -->

<!-- Default LaTeX style, but with a (sans serif) font defined above -->

<xsl:template name="titlesec-chapter-style">
    <xsl:text>\titleformat{\chapter}[display]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\huge\bfseries}{\divisionnameptx\space\thechapter}{20pt}{\Huge#1}&#xa;</xsl:text>
    <xsl:text>[{\Large\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\chapter,numberless}[display]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\huge\bfseries}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\Large\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\chapter}{0pt}{50pt}{40pt}&#xa;</xsl:text>
</xsl:template>

<!-- Horizontal rule before, plus line break          -->
<!-- Section 4.1(1ex)(title)                          -->
<!-- Horizontal rule after, but lifted                -->
<!-- Spacing after is default, likely needs reduction -->
<!-- No change to unnumbered version                  -->
<!-- N.B. Protect optional argument inside optional   -->
<!-- argument with a defensive TeX group, {}          -->

<xsl:template name="titlesec-section-style">
    <xsl:text>\titleformat{\section}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\Large\bfseries\hrulefill\\}{\divisionnameptx\space\thesection}{1ex}{#1}&#xa;</xsl:text>
    <xsl:text>[{\rule[0.8\baselineskip]{\textwidth}{0.5pt}}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\section,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\Large\bfseries}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\large\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

<!-- "subsection" are much like "section", except -->
<!--   * no rule before                           -->
<!--   * no "Subsection" string                   -->
<!--   * 90% width rule below, flush left         -->
<xsl:template name="titlesec-subsection-style">
    <xsl:text>\titleformat{\subsection}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\large\bfseries}{\thesubsection}{1ex}{#1}&#xa;</xsl:text>
    <xsl:text>[{\rule[0.8\baselineskip]{0.9\textwidth}{0.5pt}}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\subsection,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\normalfont\large\bfseries}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\normalsize\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

 <!-- subsubsections are not numbered, so are -->
 <!-- plain, just a font change from defaults -->

 <xsl:template name="titlesec-subsubsection-style">
    <xsl:text>\titleformat{\subsubsection}[hang]&#xa;</xsl:text>
    <xsl:text>{\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{#1}&#xa;</xsl:text>
    <xsl:text>[{\small\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\subsubsection,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\normalsize\bfseries}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\normalsize\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

<!-- ############ -->
<!-- Page Headers -->
<!-- ############ -->

<!-- Every page is "odd" in electronic version   -->
<!-- so no optional arguments for "even" pages   -->
<!-- Chapter (number)   (title)    (page-number) -->
<!-- NB: The "plain" style is used for the first -->
<!-- page of chapters, etc, so needs to have the -->
<!-- number styled the same.                     -->
<!-- NB: the \ifthechapter conditional stops a   -->
<!-- "Chapter 0" appearing in the front matter   -->
<!-- NB: titlesec (not titleps) provides         -->
<!-- \chaptertitlename so that the LaTeX         -->
<!-- \chaptername and \appendixname (which       -->
<!-- we internationalize) are used in the        -->
<!-- right places                                -->

<xsl:template match="book" mode="titleps-headings">
    <xsl:text>[\pageheadingfont\small]{&#xa;</xsl:text>
    <xsl:text>\sethead{\ifthechapter{\chaptertitlename\space\thechapter}{}}{\chaptertitle}{\thepage}&#xa;</xsl:text>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="book" mode="titleps-plain">
    <xsl:text>[\pageheadingfont\small]{&#xa;</xsl:text>
    <xsl:text>\setfoot{}{\thepage}{}&#xa;</xsl:text>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- ############## -->
<!-- Styling Blocks -->
<!-- ############## -->

<!-- Blue title -->
<xsl:template match="convention" mode="tcb-style">
    <xsl:text>colbacktitle=blue, coltitle=black, colframe=blue, colback=white, sharp corners=northwest</xsl:text>
</xsl:template>

<!-- Blue title, light blue body -->
<xsl:template match="list" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=blue!40!white, colframe=blue!80!black, colback=blue!10!white, coltitle=black</xsl:text>
</xsl:template>

<!-- Red title -->
<xsl:template match="remark" mode="tcb-style">
    <xsl:text>colbacktitle=red, colframe=red, coltitle=black, colback=white</xsl:text>
</xsl:template>

<!-- Red title, light red background -->
<xsl:template match="warning" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=red!80!black, colframe=red!80!black, colback=red!10!white, coltitle=black</xsl:text>
</xsl:template>

<!-- Green title -->
<xsl:template match="observation" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=green!80!black, colframe=green!80!black,fonttitle=\normalfont\bfseries, colback=white, sharp corners=west</xsl:text>
</xsl:template>

<!-- Green title, light green body -->
<xsl:template match="note" mode="tcb-style">
    <xsl:text> fonttitle=\normalfont\bfseries, colbacktitle=green!80!black, colframe=green!80!black, colback=green!10!white, coltitle=black</xsl:text>
</xsl:template>

<!-- Yellow title, light yellow body -->
<xsl:template match="insight" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=yellow, colframe=yellow, colback=yellow!10!white, coltitle=black</xsl:text>
</xsl:template>

<!-- Brown title, light brown body -->
<xsl:template match="assemblage" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=brown, colframe=brown, colback=brown!10!white, coltitle=black</xsl:text>
</xsl:template>

<!-- Brown title -->
<xsl:template match="example" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=brown, colframe=brown, colback=white, coltitle=black</xsl:text>
</xsl:template>

</xsl:stylesheet>