<?xml version='1.0'?> <!-- As XML file -->
<!-- This file is part of the book                                      -->
<!--                                                                    -->
<!--                 Sound Writing                                      -->
<!--                                                                    -->
<!-- Copyright (C) 2017-2019 by                                         -->
<!-- Cody Chun, Kieran O'Neil, Kylie Young, Julie Nelson Christoph      -->
<!--                                                                    -->
<!-- Creative Commons Attribution-ShareAlike 4.0 International License  -->
<!--                                                                    -->
<!-- Source:  https://github.com/UPS-CWLT/soundwriting                  -->
<!--                                                                    -->

<!-- For University of Puget Sound's _Sound Writing_              -->
<!-- 2019-01-27  R. Beezer, initiated to control division numbers -->
<!-- 2019-01-27  R. Beezer, do not number subsubsections          -->
<!-- 2020-05-31  R. Beezer, customization infrastructure          -->
<!-- 2021-01-31  R. Beezer, backout customization, now in PreTeXt -->

<!-- Assumes current file is in mathbook/user, so it must be copied there -->

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Stop numbering after subsections (2019-01-27: about 46 subsubsections) -->
<xsl:param name="numbering.maximum.level" select="3"/>

</xsl:stylesheet>
