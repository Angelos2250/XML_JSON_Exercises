xquery version "1.0";
(: conditional und precedes op 
<D>{ 
	let $doc := doc("./HUE/Entlassungsbrief.xml")
	
	for $diag in $doc//Diagnose[./@status = 'offen']
	order by $diag/@von ascending
	return 
		$diag
}
</D>

<D>{
	let $doc := doc("./HUE/Entlassungsbrief.xml")
	for $diag in $doc//Diagnose[./@status = 'offen']
	order by $diag/@von ascending
	return 
		<Diagnose>{
			attribute aktuell{'ja'},
			<ICD>{data($diag/@code)}</ICD>,
			<Bezeichnung>{data($diag/text())}</Bezeichnung>
		}			
		</Diagnose>
}
</D>


<Med>{
	let $doc := doc("./HUE/Entlassungsbrief.xml")
	for $arzn in $doc//Arzneimittel
	return if ( $arzn/@dosierung ne '' ) then
		<Arznei>{
			attribute morgens{substring(data($arzn/@dosierung),1,1)},
			attribute mittags{substring(data($arzn/@dosierung),3,1)},
			attribute abends{substring(data($arzn/@dosierung),5,1)},
			attribute nachts{substring(data($arzn/@dosierung),7,1)},
			$arzn/text()
		}			
		</Arznei>
		else
		<Arznei>{
			attribute hinweis{$arzn/@hinweis},
			$arzn/text()
		}			
		</Arznei>
}
</Med>


<Med>{
	let $doc := doc("./HUE/Entlassungsbrief.xml")
	for $arzn in $doc//Arzneimittel,
		$diagn in $doc//Diagnose
	return
		<Arznei>{
			attribute diagnose{$diagn/text()},
			attribute dosierung{$arzn/@dosierung},
			$arzn/text()
		}			
		</Arznei>
}
</Med>

:)

let $doc := doc("./HUE/Entlassungsbrief.xml")
for $pat in $doc//Patient
return
	<person>{
		<Name>{
		data($pat/Vorname),
		data($pat/Nachname)
		}
		</Name>,
		<Geburtsdatum>{
			attribute alter{days-from-duration(current-date()- xs:date($pat/Geburtsdatum)) div 356},
			$pat/Geburtsdatum/text()
		}
		</Geburtsdatum>
	}
	</person>