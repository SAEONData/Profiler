{
	'appname': 'SARVA',
	'spatialHierarchy',
	[
		{
			'name': 'Administrative Regions',
			'url': 'http://app01.saeon.ac.za:8081/wfs',
			'levels': [
				{ 'name': 'Province', 'wktCol', 'wktProv', 'column': 'PROV' },
				{ 'name': 'District Municipality', 'wktCol', 'wktDM', 'column': 'DCMUN', 'parentColumn', 'PROVINCE' }, 
				{ 'name': 'Local Municipality', 'wktCol', 'wktLM', 'column': 'LCMUN', 'parentColumn', 'DCMUN' }
			]
		},
		{
			'name': 'Catchments',
			'url': 'http://app01.saeon.ac.za:8082/wfs',
			'levels': [
				{ 'name': 'Primary', 'column': 'PROV' },
				{ 'name': 'Secondary', 'column': 'DCMUN' }, 
				{ 'name': 'T...', 'column': 'LCMUN' }
				{ 'name': '...', 'column': 'PROV' },
			]
		}
	]
	'variables': [
		{
			'name': 'Drivers',
			'role': 'Horizontal Axis',
			'sources': [
				{
					name: 'Fire freq',
					keyword: '#fire'
				},
				{
					name: 'Heat waves',
					keyword: '#heatwave'
				}
			]
		},
		{
			'name': 'Stocks',
			'role': 'Vert Axis',
			'sources': [
				{
					name: 'Susceptible pop',
					keyword: '#spop'
				},
				{
					name: 'Sus house holds',
					keyword: '#shold'
				}
			]
		}
	]
}

Sample View
{
	name: 'Fire Hazard',
	appname: 'SARVA',
	type: 'scatterChart'
	desc: 'bla',
	vars: [
		{
			role: 'Horizontal Axis',
			uuid: 'vcxvcx
		},
		{
			role: 'Vertical Axis',
			uuid: 'vcxvcx
		}
	]
}	


Sample metadata 
{
	name: 'Modis fires',
	keywords: '#fire #driver ~shold ~spop',
	order: 3,
	unitOfMeasure: 'kW',
	offset: 0,
	scale: 1,
	categories: {
		'ffffff': 'none',
		'ff0000': 'rarely',
		'00ff00': 'usually',
		'0000ff': 'always'
	}
}






