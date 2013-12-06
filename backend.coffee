d3 = require("d3")

search_history = []
#Returns the names and ids of relevant organisms based on user input
queryByName = (input) ->
  #Get the XML for the search query
  search_history.push input
  require("node.io").scrape ->
    @get "http://tolweb.org/onlinecontributors/app?service=external&page=xml/GroupSearchService&group=" + input, (err, data, $) ->
      parseXML data, 'name'

search = []

recursiveTreePrint = (node_list) ->
	i = 0
	while i < node_list.length #For each node in the list of nodes...
		currentNode = node_list[i]
		console.log currentNode['NAME'][0] #Prints the node name
		#console.log currentNode #Prints entire node data
		if currentNode['$']['CHILDCOUNT'] != '0' #If the node has children, print out the children
			console.log 'Children: ' + currentNode['$']['CHILDCOUNT']
			recursiveTreePrint(currentNode['NODES'][0]['NODE']) #Does the child have children? Recursion!
		i++

parseXML = (xml, type) ->
  #console.log xml
  #Parse the XML to JSON
  if type == 'name'
	  parseString = require("xml2js").parseString
	  parseString xml, (err, result) ->
	    search.push result
	    for s in search
	    	count = s['NODES']['$']['COUNT']
	    	node_list = s['NODES']['NODE']
	    	i = 0
	    	while i < count
	    		id = node_list[i]['$']['ID']
	    		name = node_list[i]['NAME'][0]
	    		console.log id, name
	    		queryByID(id)
	    		i++
  else
  	parseString = require("xml2js").parseString
	  parseString xml, (err, result) ->
	  	tree = result['TREE']
	  	node_list = tree['NODE']
	  	recursiveTreePrint node_list
	  		

queryByName 'Humans'

#Gets the tree of the organism based on its ID
queryByID = (input) ->
  #Get the XML for the search query
  require("node.io").scrape ->
    @get "http://tolweb.org/onlinecontributors/app?service=external&page=xml/TreeStructureService&node_id=" + input, (err, data, $) ->
    	#console.log data
    	parseXML data, 'tree'


