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
    <xsl:text>\newfontfamily{\pagefont}{texgyrepagella-regular.otf}[Path=/usr/share/texmf/fonts/opentype/public/tex-gyre/,ItalicFont=texgyrepagella-italic.otf,BoldFont=texgyrepagella-bold.otf,BoldItalicFont=texgyrepagella-bolditalic.otf]&#xa;</xsl:text>
</xsl:param>

<!-- #######-->
<!-- Colors -->
<!-- #######-->

<!-- Selected from UPS maroon-compatibility chart  -->
<!-- UPS Communications Office, 2019-10-04         -->
<!-- Not every color may be in use, due to changes -->
<!-- 2019-12-30, muted3 is free                    -->
<xsl:template name="xcolor-style">
    <xsl:text>\definecolor{maroon}{HTML}{660000}&#xa;</xsl:text>
    <xsl:text>\definecolor{neutral1}{HTML}{d0ccbd}&#xa;</xsl:text>
    <xsl:text>\definecolor{muted2}{HTML}{d0c681}&#xa;</xsl:text>
    <xsl:text>\definecolor{muted3}{HTML}{b1a77d}&#xa;</xsl:text>
    <xsl:text>\definecolor{muted4}{HTML}{93a396}&#xa;</xsl:text>
    <xsl:text>\definecolor{muted5}{HTML}{a2bac2}&#xa;</xsl:text>
    <xsl:text>\definecolor{bright4}{HTML}{b4bd00}&#xa;</xsl:text>
    <xsl:text>\definecolor{bright5}{HTML}{6c712f}&#xa;</xsl:text>
    <xsl:text>\definecolor{bright6}{HTML}{48848d}&#xa;</xsl:text>
</xsl:template>


<!-- ################# -->
<!-- Division Headings -->
<!-- ################# -->

<!-- Default LaTeX style, but with a (sans serif) font defined above -->
<!-- All division headings are in maroon color, defined above        -->

<xsl:template name="titlesec-chapter-style">
    <xsl:text>\titleformat{\chapter}[display]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\huge\bfseries\color{maroon}}{\divisionnameptx\space\thechapter}{20pt}{\Huge#1}&#xa;</xsl:text>
    <xsl:text>[{\Large\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\chapter,numberless}[display]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\huge\bfseries\color{maroon}}{}{0pt}{#1}&#xa;</xsl:text>
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
    <xsl:text>{\divisionheadingfont\Large\bfseries\color{maroon}\hrulefill\\}{\divisionnameptx\space\thesection}{1ex}{#1}&#xa;</xsl:text>
    <xsl:text>[{\rule[0.8\baselineskip]{\textwidth}{0.5pt}}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\section,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\Large\bfseries\color{maroon}}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\large\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

<!-- "subsection" are much like "section", except -->
<!--   * no rule before                           -->
<!--   * no "Subsection" string                   -->
<!--   * 90% width rule below, flush left         -->
<xsl:template name="titlesec-subsection-style">
    <xsl:text>\titleformat{\subsection}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\large\bfseries\color{maroon}}{\thesubsection}{1ex}{#1}&#xa;</xsl:text>
    <xsl:text>[{\rule[0.8\baselineskip]{0.9\textwidth}{0.5pt}}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\subsection,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\normalfont\large\bfseries\color{maroon}}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\normalsize\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

 <!-- subsubsections are not numbered, so are -->
 <!-- plain, just a font change from defaults -->

 <xsl:template name="titlesec-subsubsection-style">
    <xsl:text>\titleformat{\subsubsection}[hang]&#xa;</xsl:text>
    <xsl:text>{\normalfont\normalsize\bfseries\color{maroon}}{\thesubsubsection}{1em}{#1}&#xa;</xsl:text>
    <xsl:text>[{\small\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\subsubsection,numberless}[block]&#xa;</xsl:text>
    <xsl:text>{\divisionheadingfont\normalsize\bfseries\color{maroon}}{}{0pt}{#1}&#xa;</xsl:text>
    <xsl:text>[{\normalsize\authorsptx}]&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}&#xa;</xsl:text>
</xsl:template>

<!-- ############ -->
<!-- Page Headers -->
<!-- ############ -->

<!-- Every page is "odd" in electronic version   -->
<!-- so no optional arguments for "even" pages   -->
<!-- Section (number)   (title)    (page-number) -->
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

<xsl:template match="book" mode="titleps-style">
    <xsl:text>%% Page style configuration for Sound Writing&#xa;</xsl:text>
    <xsl:text>%% Assumes one-sided printing&#xa;</xsl:text>
    <xsl:text>%%&#xa;</xsl:text>
    <xsl:text>%% Plain pages should have the same font for page numbers&#xa;</xsl:text>
    <xsl:text>\renewpagestyle{plain}{%&#xa;</xsl:text>
    <xsl:text>\setfoot{}{\pagefont\thepage}{}%&#xa;</xsl:text>
    <xsl:text>}%&#xa;</xsl:text>
    <xsl:text>\renewpagestyle{headings}{%&#xa;</xsl:text>
    <xsl:text>\pagefont\headrule%&#xa;</xsl:text>
    <xsl:text>\sethead%&#xa;</xsl:text>
    <xsl:text>{\ifthesection{\pagefont\thesection}{\ifthechapter{\pagefont\thechapter}{}}}%&#xa;</xsl:text>
    <xsl:text>{{\pagefont\space\ifthesection{\sectiontitle}{\chaptertitle}\space}}%&#xa;</xsl:text>
    <xsl:text>{\pagefont\thepage}%&#xa;</xsl:text>
    <xsl:text>}%&#xa;</xsl:text>
    <xsl:text>\pagestyle{headings}&#xa;</xsl:text>
</xsl:template>


<!-- ############## -->
<!-- Styling Blocks -->
<!-- ############## -->

<!-- 2019-12-30: "example": 107 -->
<!-- Julie Christoph, 2019-12-30, muted5, UPS 7542 -->
<xsl:template match="example" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=muted5, colframe=maroon, colback=muted5, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-30: "list": 88 -->
<!-- Julie Christoph, 2019-12-30, neutral1 UPS 7534 -->
<xsl:template match="list" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=neutral1, colframe=maroon, colback=neutral1, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-16: "note": 35 -->
<!-- Julie Christoph, 2019-12-30, muted4, UPS 5635 -->
<xsl:template match="note" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=muted4, colframe=maroon, colback=muted4, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-30: "insight": 20 -->
<!-- Renamed as a "Tip"        -->
<!-- Julie Christoph, 2019-12-30, muted2, UPS 616 -->
<xsl:template match="insight" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=muted2, colframe=maroon, colback=muted2, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-30: "observation": 16     -->
<!-- Renamed as a "Student Perspective" -->
<!-- Julie Christoph, 2019-12-30, muted3, UPS 5483 -->
<xsl:template match="observation" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=bright6, colframe=maroon, colback=bright6, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-30: "convention": 10     -->
<!-- Renamed as a "Helpful Questions" -->
<!-- Julie Christoph, 2019-12-30, muted3, UPS 452 -->
<xsl:template match="convention" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=muted3, colframe=maroon, colback=muted3, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

<!-- 2019-12-16: "warning": 6 -->
<!-- Julie Christoph, 2019-12-30, bright, UPS 390 -->
<xsl:template match="warning" mode="tcb-style">
    <xsl:text>fonttitle=\normalfont\bfseries, colbacktitle=bright4, colframe=maroon, colback=bright4, coltitle=black, titlerule=-0.3pt,</xsl:text>
</xsl:template>

</xsl:stylesheet>