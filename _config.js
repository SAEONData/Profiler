{
	'title': 'SARVA 2',
	'description': 'The South African Risk and Vulnerability Atlas (SARVA) is sponsored by the Department of Science and Technology (DST) and managed by the CSIR and is intended to be a central repository of a wide range of climate and environmental data for South Africa.  CSAG is both a technical partner in the development as well as being mandated to provide high resolution downscaled climate projections as a core dataset within the Atlas.  In the future the CSAG/UNITAR Climate Information Portal (CIP) and SARVA will be more closely integrated with direct links to the CIP web client and possible integration of CIP components into the SARVA platform.',
	'mindmup': 'mm/RoadshowStocks2.txt',
	'rootStock': 'Stocks',
	'rootDriver': 'Pressure',
	'features': [
		{
			'name': 'Municipalities', 
			'url': 'http://app01.saeon.ac.za:8085/geoserver/ows?service=wfs&version=1.1.0', 
			'layer': 'BEA_shp:MN_SA_2011', 
			'style': '', 
			'field': 'MN_NAME' 
		},
		{
			'name': 'Provinces', 
			'url': 'http://app01.saeon.ac.za:8085/geoserver/ows?service=wfs&version=1.1.0', 
			'layer': 'BEA_shp:PR_SA_2011', 
			'style': '',
			'field': 'PR_NAME'
		}
	]
}