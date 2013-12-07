width = 300
height = 300
history = []

socket = io.connect("http://localhost:3000")
$("#submit").on "click", (event) ->
  event.preventDefault()
  $("#loading").attr("style", style="visibility: visible;")
  $("#diverged").attr("style", style="visibility: hidden;")
  socket.emit "search",
    A: $("#searchA").val()
    B: $("#searchB").val()

socket.on "callback", (data) ->
  if data[2]  == null
    $("#loading").attr("style", style="visibility: hidden;")
    alert('I apologize, no results found!\n\nTry using the scientific names for organisms!')
  else
    #console.log data[2]
    #console.log data[3]
    $("#loading").attr("style", style="visibility: hidden;")
    $("#diverged").attr("style", style="visibility: visible;")
    $("#info").html("diverged " + data[2])
    if $.inArray(data[0],history) == -1
      history.push data[0]    
      
        #Graph A
      d3.select "svg"
      color = d3.scale.category20()
      force = d3.layout.force().charge(-120).linkDistance(30).size([width, height])
      scale = 1.0
      
      #The left graph
      svgA = d3.select("#graph-left").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
      graphA = $.parseJSON(data[0])
      console.log graphA
      force.nodes(graphA.nodes).links(graphA.links).start()
      link = svgA.selectAll(".link").data(graphA.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
        Math.sqrt d.value
      )
      node = svgA.selectAll(".node").data(graphA.nodes).enter().append("circle").attr("class", "node").attr("r", 10).style("fill", (d) ->
        color d.group
      ).call(force.drag)
      node.append("title").text (d) ->
        d.name

      force.on "tick", ->
        link.attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr "y2", (d) ->
          d.target.y

        node.attr("cx", (d) ->
          d.x
        ).attr "cy", (d) ->
          d.y

    if $.inArray(data[1],history) == -1
      history.push data[1]
      #Graph B
      color = d3.scale.category20()
      forceB = d3.layout.force().charge(-120).linkDistance(30).size([width, height])
      scale = 1.0
      
      #The right graph
      d3.select("svg")
      svgB = d3.select("#graph-right").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
      graphB = $.parseJSON(data[1])
      console.log graphB
      forceB.nodes(graphB.nodes).links(graphB.links).start()
      linkB = svgB.selectAll(".link").data(graphB.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
        Math.sqrt d.value
      )
      nodeB = svgB.selectAll(".node").data(graphB.nodes).enter().append("circle").attr("class", "node").attr("r", 10).style("fill", (d) ->
        color d.group
      ).call(forceB.drag)
      nodeB.append("title").text (d) ->
        d.name

      forceB.on "tick", ->
        linkB.attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr "y2", (d) ->
          d.target.y

        nodeB.attr("cx", (d) ->
          d.x
        ).attr "cy", (d) ->
          d.y


