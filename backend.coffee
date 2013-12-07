d3 = require("d3") #Not sure if necessary on the backend, since graphics can't be drawn here
express = require("express")
app = express()
app.listen 3000
console.log 'Backend listening on port 3000...'

#recursive_limit = 0
#recursive_count = 0

json_list = []

sendToFront = (data) ->
	#console.log 'Data sent.'
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
		results.push currentNode['NAME'][0] #Pushes the node onto results
		#console.log currentNode['NAME'][0] #Prints the node name
		#console.log currentNode #Prints entire node data
		if currentNode['$']['CHILDCOUNT'] != '0' #and (recursive_count < recursive_limit) #If the node has children, print out the children
			#console.log '{\"name\":' + '\"' + currentNode['NAME'][0] + '\",' + '\"group\":' + (i+1) + '},'
			#sendToFront 'Children: ' + currentNode['$']['CHILDCOUNT']
			#console.log 'Children: ' + currentNode['$']['CHILDCOUNT']
			childrenNumber = Number(currentNode['$']['CHILDCOUNT'])
			c = 0
			while c < childrenNumber
				links += '{\"source\":' + (i + c + 1) + ',\"target\":' + i + ',\"value\":' + 1 + '},'
				#console.log '{\"source\":' + (i + c + 1) + ',\"target\":' + i + ',\"value\":' + 1 + '},'
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
  	#console.log 'Tree'
  	parseString = require("xml2js").parseString
	  parseString xml, (err, result) ->
	  	tree = result['TREE']
	  	node_list = tree['NODE']
	  	recursiveTreePrint node_list
	  	nodes = nodes[0..nodes.length-1]
	  	links = links[0..links.length-1]
	  json = '{' + nodes[0..nodes.length-2] + '],' + '\"links\":[' + links[0..links.length-2] + ']' + '}'
	  if json[-3..json.length-2] != '[]'
	  	sendToFront json
		#console.log json

#Gets the tree of the organism based on its ID
queryByID = (input) ->
  #Get the XML for the search query
  require("node.io").scrape ->
    @get "http://tolweb.org/onlinecontributors/app?service=external&page=xml/TreeStructureService&node_id=" + input, (err, data, $) ->
    	#console.log data
    	parseXML data, 'tree'

#queryByName 'Human'

#Finds how many years ago two organisms diverged
queryDivergence = (taxon_a, taxon_b) ->
	phantom = require("node-phantom")
	phantom.create (err, ph) ->
	  ph.createPage (err, page) ->
	    page.open "http://timetree.org/index.php?taxon_a=" + taxon_a + "&taxon_b=" + taxon_b + "&submit=Search", (err, status) ->
	      #console.log "Opened site? ", status
	      page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js", (err) ->
	        #jQuery Loaded.
	        #Wait for a bit for AJAX content to load on the page. Here, we are waiting 0.1 seconds.
	        #setTimeout (->
	          page.evaluate (->
	            #Get what you want from the page using jQuery. A good way is to populate an object with all the jQuery commands that you need and then return the object.
	            time = []
	            taxon_a_history = []
	            taxon_b_history = []
	            years = []
	            $(".time").each ->
	              time.push $(this).html()
	            $('table#timetreetimeline tr').each ->
	            	count = 0
	            	$(this).find("td").map(->
	            		if count%5 == 0
	            			years.push $(this).html()

	            		else if count%5 == 1
	            			$(this).find("i").map(->
	            				taxon_a_history.push $(this).html()
	            			)
	            		else if count%5 == 2
	            			$(this).find("i").map(->
	            				taxon_b_history.push $(this).html()
	            			)	
	            		count++
	            	)
	            a_timeline = {}
	            b_timeline = {}
	            i = 0
	            while i < years.length
	            	a_timeline[years[i]] = taxon_a_history[i]
	            	b_timeline[years[i]] = taxon_b_history[i]
	            	i++
	            diverged: time #A list of estimated divergence times (evolutionary distance in terms of years)
	            timeline: years #A list of years when known common ancestors existed between taxon a and taxon b
	            a_history: taxon_a_history #A list of taxon a ancestors
	            b_history: taxon_b_history #A list of taxon b ancestors
	            a_timeline: a_timeline #A dictionary with years as keys and taxon a ancestors as values
	            b_timeline: b_timeline #A dictionary with years as keys and taxon b ancestors as values
	          ), (err, result) ->
	            #console.log(result["diverged"][0])
	            #console.log(result["timeline"], result["a_history"], result["b_history"])
	            console.log(result["a_timeline"])
	            console.log(result["b_timeline"])
	            ph.exit()
	        #), 100


queryDivergence('human', 'dog')


