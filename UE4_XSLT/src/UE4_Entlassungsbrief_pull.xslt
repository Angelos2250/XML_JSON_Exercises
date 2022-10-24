<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.fh-ooe.at/ssd4/entlassungsbrief" xpath-default-namespace="http://www.fh-ooe.at/ssd4/entlassungsbrief">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:include href="DiagnoseICD.xslt"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Entlassungsbrief</title>
                <style type="text/css">
                    table.t2 {
                        border-collapse: collapse;
                        font-family: Georgia;
                      }
                      .t2 caption {
                        padding-bottom: 0.5em;
                        font-weight: bold;
                        font-size: 16px;
                      }
                      .t2 th, .t2 td {
                        padding: 4px 8px;
                        border: 2px solid #fff;
                        background: #bdd2d9;
                      }
                      .t2 thead th {
                        padding: 2px 8px;
                        background: #328da8;
                        text-align: left;
                        font-weight: normal;
                        font-size: 13px;
                        color: #fff;
                      }
                      .t2 tr *:nth-child(3), .t2 tr *:nth-child(4) {
                        text-align: right;
                      }                </style>
            </head>
            <body>
                <xsl:call-template name="Entlassungsbrief"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="Entlassungsbrief">
        <h1>Entlassungsbrief</h1>
        Version <xsl:value-of select="/Entlassungsbrief/@version"/> vom 
              <xsl:value-of select='format-dateTime(/Entlassungsbrief/@erzeugt, 
                              "[D]. [MNn] [Y] um [H01]:[m01] Uhr", "de", (), ())'/>
        <xsl:call-template name="Formatierung"/>
        <xsl:call-template name="Ersteller"/>
        <xsl:call-template name="Empfänger"/>
        <xsl:call-template name="Patient"/>
        <xsl:call-template name="Aufenthalt"/>
        <xsl:call-template name="Befundtext"/>
        <xsl:call-template name="Diagnosen"/>
        <xsl:call-template name="Medikation"/>
    </xsl:template>
    
    <!--TBD-->
    <xsl:template name="Formatierung">
		<hr/>
	</xsl:template>
	
	<xsl:template name="Ersteller">
		<strong>Erstellt von: </strong>
		<xsl:value-of select="//Ersteller"/>
		<br/>
	</xsl:template>
	
	<xsl:template name="Empfänger">
		<strong>An: </strong>
		<xsl:value-of select="//Empfänger"/>
		<br/>
	</xsl:template>
	
	<xsl:template name="Patient">
		<h2>Patient: </h2>
		<xsl:value-of select="//Titel[@position='vor']"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="//Vorname"/> 
		<xsl:text> </xsl:text>
		<xsl:value-of select="//Nachname"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="//Titel[@position='nach']"/><br/>
		<strong>Geschlecht: </strong>
		<xsl:value-of select="//Geschlecht"/>
		<xsl:text> | </xsl:text>
		<strong>geboren am: </strong>
		<xsl:value-of select="format-date(//Geburtsdatum, '[D] [MNn] [Y]', 'de', (), ())"/>
		<xsl:text> | </xsl:text>
		<strong>SVN: </strong>
		<xsl:value-of select="//SVN"/><br/>
	</xsl:template>
	
	<xsl:template name="Aufenthalt">
		<h2>Aufenthalt: </h2>
		<xsl:value-of select="//Aufenthalt"/>
		<br/>
		<strong>
			<xsl:value-of 
			select="//Aufenthalt/@art"/> 
		</strong>
		<strong> von: </strong>
		<xsl:value-of select="format-date(//Aufenthalt/@von, '[D] [MNn] [Y]', 'de', (), ())"/>
		<strong> bis: </strong>
		<xsl:value-of select="format-date(//Aufenthalt/@bis, '[D] [MNn] [Y]', 'de', (), ())"/>
	</xsl:template>
	
	<xsl:template name="Befundtext">
		<hr/>
		<xsl:value-of select="//Anrede"/><br/><br/>
			<xsl:value-of select="//Text"/>
		<hr/>
	</xsl:template>
	
	<xsl:template name="Diagnosen">
		<xsl:variable name="dias" select="//Diagnosen"/>
		<h2>aufrechte Diagnosen bei Entlassung</h2>
		<table class="t2">
			<thead>
				<tr>
					<th>Diagnose</th>
					<th>Datum von</th>
					<th>Datum bis</th>
					<th>Status</th>
					<th>ICD-INFO</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$dias/Diagnose[@status='offen']">
				<tr>
					<td>
						<strong><xsl:value-of select="@code"/></strong>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</td>
					<td>
						<xsl:value-of select="format-date(@von, '[D].[M].[Y]')"/>
					</td>
					<td>
						<xsl:value-of select="format-date(@bis, '[D].[M].[Y]')"/>
					</td>
					<td>
						<xsl:value-of select="@status"/>
					</td>
					<td>
						<xsl:call-template name="selectICDForDiagnose">
							<xsl:with-param name="diagnose" select="@code"/>
						</xsl:call-template>
					</td>
				</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template name="Medikation">
		<xsl:variable name="meds" select="//Medikation"/>
		<xsl:if test="$meds">
			<h2>Empfohlene Medikation (aktuell)</h2>
			<table class="t2">
			<thead>
				<tr>
					<th>Arzneimittel</th>
					<th>Einnahme</th>
					<th>Dosierung</th>
					<th align="right">Hinweis</th>
					<th>Zusatzinformationen</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$meds/Arzneimittel[not(@bis)]">
					<tr>
						<td>
							<strong>
								<xsl:value-of select="."/>
							</strong>
						</td>
						<td>
							<xsl:value-of select="@einnahme"/>
						</td>
						<td>
							<xsl:value-of select="@dosierung"/>
						</td>
						<td align="right">
							<xsl:value-of select="@hinweis"/>
						</td>
						<td>
							<xsl:if test="@von">
								<strong>Start: </strong>
								<xsl:value-of select="format-date(@von, '[D].[M].[Y]')"/>
								<br/>
							</xsl:if>
							<xsl:if test="@bis">
								<strong>Ende: </strong>
								<xsl:value-of select="format-date(@bis, '[D].[M].[Y]')"/>
								<br/>
							</xsl:if>
							<strong>Anwendung: </strong>
							<xsl:value-of select="@anwendung"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
