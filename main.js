
function query(input) {
	require('node.io').scrape(function() {
	    this.get('http://tolweb.org/onlinecontributors/app?service=external&page=xml/GroupSearchService&group=' + input, function(err, data, $) {
	        parseXML(data);
	    });
	});
}

function parseXML(xml) {
	//Parse the XML to JSON
    var parseString = require('xml2js').parseString;
	parseString(xml, function (err, result) {
    	console.dir(result);
	});
}

query('Homo Sapiens');