
var request = require("request");

var parseXML = function(xml) {
    //Parse the XML to JSON
    var parseString = require('xml2js').parseString;
	parseString(xml, function (err, result) {
    	console.dir(result);
	});
};

//Function to find a node based on organism name
function query(input) {
	request("http://tolweb.org/onlinecontributors/app?service=external&page=xml/GroupSearchService&group=" + input, function (error, response, body) {
	    if (!error) {
	        parseXML(body);
	    } else {
	        console.log(error);
	    }
	});
}

query('Homo Sapiens');