d3 = require("d3") #Not sure if necessary on the backend, since graphics can't be drawn here
express = require("express")
app = express()
app.listen 3000
console.log 'Backend listening on port 3000...'

#recursive_limit = 0
#recursive_count = 0

json_list = []

sendToFront = (data) ->
	app.get "/search_result", (req, res) ->
	  # CSP headers
	  res.set "Access-Control-Allow-Origin", "*"
	  res.set "Access-Control-Allow-Headers", "X-Requested-With"
	  # Response
	  res.send data

search_history = []
#Returns the names and ids of relevant organisms based on user input
queryByName = (input) ->
  #Get the XML for the search query
  search_history.push input
  require("node.io").scrape ->
    @get "http://tolweb.org/onlinecontributors/app?service=external&page=xml/GroupSearchService&group=" + input, (err, data, $) ->
      parseXML data, 'name'

search = []
results = [] #Stores the nodes of the search
json = ''
nodes = '\"nodes\":['
# links = '\"links\":['
links = ''
recursiveTreePrint = (node_list) ->
	i = 0
	while i < node_list.length #For each node in the list of nodes...
		currentNode = node_list[i]
		nodes += '{\"name\":' + '\"' + currentNode['NAME'][0] + '\",' + '\"group\":' + (i+1) + '},'
		
		#console.log nodes

		results.push currentNode['NAME'][0] #Pushes the node onto results
		console.log currentNode['NAME'][0] #Prints the node name
		#console.log currentNode #Prints entire node data
		if currentNode['$']['CHILDCOUNT'] != '0' #and (recursive_count < recursive_limit) #If the node has children, print out the children
			console.log '{\"name\":' + '\"' + currentNode['NAME'][0] + '\",' + '\"group\":' + (i+1) + '},'
			#sendToFront 'Children: ' + currentNode['$']['CHILDCOUNT']
			console.log 'Children: ' + currentNode['$']['CHILDCOUNT']
			childrenNumber = Number(currentNode['$']['CHILDCOUNT'])
			c = 0
			while c < childrenNumber
				links += '{\"source\":' + (i + c + 1) + ',\"target\":' + i + ',\"value\":' + 1 + '},'
				console.log '{\"source\":' + (i + c + 1) + ',\"target\":' + i + ',\"value\":' + 1 + '},'
				c++
			recursiveTreePrint(currentNode['NODES'][0]['NODE']) #Does the child have children? Recursion!
			#recursive_count++
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
	    		console.log id, name + ' ***'
	    		if id != '' and name != ''
	    			queryByID(id)
	    		i++
  else
  	console.log 'Tree'
  	parseString = require("xml2js").parseString
	  parseString xml, (err, result) ->
	  	tree = result['TREE']
	  	node_list = tree['NODE']
	  	recursiveTreePrint node_list
	  	nodes = nodes[0..nodes.length-1]
	  	links = links[0..links.length-1]
	  json = '{' + nodes[0..nodes.length-2] + '],' + '\"links\":[' + links[0..links.length-2] + ']' + '}'
	  console.log '*******JSON*******'
	  #console.log json
	  #json_list.push json
	  if json[-3..json.length-2] != '[]'
	  	sendToFront json
		console.log json

#Gets the tree of the organism based on its ID
queryByID = (input) ->
  #Get the XML for the search query
  require("node.io").scrape ->
    @get "http://tolweb.org/onlinecontributors/app?service=external&page=xml/TreeStructureService&node_id=" + input, (err, data, $) ->
    	#console.log data
    	parseXML data, 'tree'

queryByName 'Human'

#sendToFront 'Hi'