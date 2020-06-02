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

<!-- Assumes current file is in mathbook/user, so it must be copied there -->

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Stop numbering after subsections (2019-01-27: about 46 subsubsections) -->
<xsl:param name="numbering.maximum.level" select="3"/>

<!-- ######################### -->
<!-- # Custom Content template -->
<!-- ######################### -->

<!-- default to using generic customizations, especially -->
<!-- so subsequent document() open does not fail         -->
<!-- This can be passed in via script variables          -->
<xsl:param name="school" select="'generic'"/>

<!-- The translations in a structured XML file,          -->
<!-- indexed by school name in the file name             -->
<!-- The "/pretext" argument means the relative filename -->
<!-- is resolved relative to the master source file      -->
<xsl:variable name="school-customizations" select="document(concat('customizations/', $school, '.ptx'), /pretext)"/>

<!-- Set the key, nodes to be located are named    -->
<!-- "school-custom" within the file just accessed -->
<!-- For each one, @type is the search term that   -->
<!-- will locate it: the key, the index            -->
<xsl:key name="school-key" match="school-custom" use="@type"/>

<!-- custom and custom/@item are the source nodes that guide the customization -->
<!-- The value of @item will be the search term within $school-customizations  -->
<xsl:template match="custom" mode="assembly">
    <!-- We need the @item attribute due to a context shift  -->
    <!-- later, but we can also error-check it this way      -->
    <xsl:variable name="the-item">
        <xsl:value-of select="@item"/>
    </xsl:variable>
    <xsl:if test="$the-item = ''">
        <xsl:message>SW:WARNING:   a "custom" element lacks a value for the @item attribute</xsl:message>
        <xsl:apply-templates select="." mode="location-report"/>
    </xsl:if>
    <!-- And we will save the "custom" context also  -->
    <!-- for reporting a lookup failure below -->
    <xsl:variable name="the-custom" select="."/>
    <!-- Now a context shift to allow access to the customizations -->
    <xsl:for-each select="$school-customizations">
        <xsl:variable name="the-lookup" select="key('school-key', $the-item)"/>
        <xsl:if test="not($the-lookup)">
            <xsl:text>[MISSING CUSTOM CONTENT HERE]</xsl:text>
            <xsl:message>SW:WARNING:   lookup for a "custom" element with @item set to "<xsl:value-of select="$the-item"/>" has failed, while consulting <xsl:value-of select="concat($school, '.ptx')"/>.  Output will contain "[MISSING CUSTOM CONTENT HERE]" instead</xsl:message>
            <xsl:apply-templates select="$the-custom" mode="location-report"/>
        </xsl:if>
        <!-- <xsl:text>{\LARGE\color{red}</xsl:text> -->
        <xsl:copy-of select="$the-lookup"/>
        <!-- <xsl:text>}</xsl:text> -->
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>