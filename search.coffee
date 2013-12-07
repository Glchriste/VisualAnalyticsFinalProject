#search.coffee

search = (taxon_a, taxon_b) ->
	phantom = require("node-phantom")
	phantom.create (err, ph) ->
	  ph.createPage (err, page) ->
	    page.open "http://timetree.org/index.php?taxon_a=" + taxon_a + "&taxon_b=" + taxon_b + "&submit=Search", (err, status) ->
	      console.log "opened site? ", status
	      page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js", (err) ->
	        #jQuery Loaded.
	        #Wait for a bit for AJAX content to load on the page. Here, we are waiting 5 seconds.
	        setTimeout (->
	          page.evaluate (->
	            
	            #Get what you want from the page using jQuery. A good way is to populate an object with all the jQuery commands that you need and then return the object.
	            time = []
	            $(".time").each ->
	              time.push $(this).html()

	            times: time
	          ), (err, result) ->
	            console.log(result["times"][0])
	            ph.exit()
	        ), 5000


search('cat', 'dog')