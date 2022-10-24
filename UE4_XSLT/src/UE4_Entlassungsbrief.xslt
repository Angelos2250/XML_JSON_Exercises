<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.fh-ooe.at/ssd4/entlassungsbrief" xpath-default-namespace="http://www.fh-ooe.at/ssd4/entlassungsbrief">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
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
					  }
				</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="Entlassungsbrief">
		<h1>Entlassungsbrief</h1>
		Version <xsl:value-of select="@version"/> vom <xsl:value-of select='format-dateTime(@erzeugt, "[D]. [MNn] [Y] um [H01]:[m01] Uhr", "de", (), ())'/>
		<hr/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!--TBD-->
	<xsl:template match="Ersteller">
		<strong>Erstellt von:</strong>
		<xsl:value-of select="."></xsl:value-of><br/>
	</xsl:template> 
	
	<xsl:template match="Empfänger">
		<strong>An: </strong>
		<xsl:value-of select="."></xsl:value-of><br/>
	</xsl:template>
	
	<xsl:template match="Patient">
		<h2>Patient</h2>
		<xsl:value-of select="Titel[@position='vor']"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="Vorname"/> 
		<xsl:text> </xsl:text>
		<xsl:value-of select="Nachname"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="Titel[@position='nach']"/><br/>
		<strong>Geschlecht: </strong>
		<xsl:value-of select="Geschlecht"/>
		<xsl:text> | </xsl:text>
		<strong>geboren am: </strong>
		<xsl:value-of select="format-date(Geburtsdatum, '[D] [MNn] [Y]', 'de', (), ())"/>
		<xsl:text> | </xsl:text>
		<strong>SVN: </strong>
		<xsl:value-of select="SVN"/><br/>
		
	</xsl:template>
	
	<xsl:template match="Aufenthalt">
		<h2>Aufenthalt: </h2>
		<xsl:value-of select="."/>
		<br/>
		<strong>
			<xsl:value-of 
			select="@art"/> 
		</strong>
		<strong> von: </strong>
		<xsl:value-of select="format-date(@von, '[D] [MNn] [Y]', 'de', (), ())"/>
		<strong> bis: </strong>
		<xsl:value-of select="format-date(@bis, '[D] [MNn] [Y]', 'de', (), ())"/>
	</xsl:template>

	<xsl:template match="Befundtext">
		<hr/>
		<xsl:value-of select="Anrede"/><br/><br/>
			<xsl:value-of select="Text"/>
		<hr/>
	</xsl:template>
	
	<xsl:template match="Diagnosen">
		<h2>Diagnosen bein Entlassung</h2>
		<table class="t2">
			<thead>
				<tr>
					<th>Diagnose</th>
					<th>Datum von</th>
					<th>Datum bis</th>
					<th align="right">Status</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="./Diagnose"/>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="Diagnose">
		<tr>
			<td>
				<strong>
					<xsl:value-of select="@code"/>
				</strong>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="."/>
			</td>
			<td>
				<xsl:value-of select="format-date(@von, '[D].[M].[Y]')"/>
			</td>
			<td>
				<xsl:value-of select="format-date(@bis, '[D].[M].[Y]')"/>
			</td>
			<td align="right">
				<xsl:value-of select="@status"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Medikation">
		<h2>Empfohlene Medikation</h2>
		<table class="t2">
			<thead>
				<tr>
					<th>Arzneimittel</th>
					<th>Einnahme</th>
					<th>Dosierung</th>
					<th align="right">Hinweis</th>
					<th>Diagnose</th>
					<th>Zusatzinformationen</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="./Arzneimittel"/>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="Arzneimittel">
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
				<xsl:value-of select="@diagnose"/>
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
	</xsl:template>
	
</xsl:stylesheet>
