socket = io.connect("http://localhost:3000")
$("#submit").on "click", (event) ->
  event.preventDefault()
  socket.emit "search",
    A: $("#searchA").val()
    B: $("#searchB").val()


socket.on "callback", (data) ->
  console.log data
    #Graph A
  d3.select "svg"
  width = 400
  height = 400
  color = d3.scale.category20()
  force = d3.layout.force().charge(-120).linkDistance(50).size([width, height])
  scale = 1.0
  
  #The left graph
  svgA = d3.select("#graph-left").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
  graphA = $.parseJSON(data[0])
  console.log graphA
  force.nodes(graphA.nodes).links(graphA.links).start()
  link = svgA.selectAll(".link").data(graphA.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
    Math.sqrt d.value
  )
  node = svgA.selectAll(".node").data(graphA.nodes).enter().append("circle").attr("class", "node").attr("r", 7).style("fill", (d) ->
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

  #Graph B
  width = 400
  height = 400
  color = d3.scale.category20()
  forceB = d3.layout.force().charge(-120).linkDistance(50).size([width, height])
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
  nodeB = svgB.selectAll(".node").data(graphB.nodes).enter().append("circle").attr("class", "node").attr("r", 7).style("fill", (d) ->
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



# $.get "http://localhost:3000/search_result", (data) ->
#   console.log data
#   #Graph A
#   d3.select "svg"
#   width = 400
#   height = 400
#   color = d3.scale.category20()
#   force = d3.layout.force().charge(-120).linkDistance(50).size([width, height])
#   scale = 1.0
  
#   #The left graph
#   svgA = d3.select("#graph-left").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
#   graphA = $.parseJSON(data[0])
#   console.log graphA
#   force.nodes(graphA.nodes).links(graphA.links).start()
#   link = svgA.selectAll(".link").data(graphA.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
#     Math.sqrt d.value
#   )
#   node = svgA.selectAll(".node").data(graphA.nodes).enter().append("circle").attr("class", "node").attr("r", 7).style("fill", (d) ->
#     color d.group
#   ).call(force.drag)
#   node.append("title").text (d) ->
#     d.name

#   force.on "tick", ->
#     link.attr("x1", (d) ->
#       d.source.x
#     ).attr("y1", (d) ->
#       d.source.y
#     ).attr("x2", (d) ->
#       d.target.x
#     ).attr "y2", (d) ->
#       d.target.y

#     node.attr("cx", (d) ->
#       d.x
#     ).attr "cy", (d) ->
#       d.y

#   #Graph B
#   width = 400
#   height = 400
#   color = d3.scale.category20()
#   forceB = d3.layout.force().charge(-120).linkDistance(50).size([width, height])
#   scale = 1.0
  
#   #The right graph
#   d3.select("svg")
#   svgB = d3.select("#graph-right").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
#   graphB = $.parseJSON(data[1])
#   console.log graphB
#   forceB.nodes(graphB.nodes).links(graphB.links).start()
#   linkB = svgB.selectAll(".link").data(graphB.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
#     Math.sqrt d.value
#   )
#   nodeB = svgB.selectAll(".node").data(graphB.nodes).enter().append("circle").attr("class", "node").attr("r", 7).style("fill", (d) ->
#     color d.group
#   ).call(forceB.drag)
#   nodeB.append("title").text (d) ->
#     d.name

#   forceB.on "tick", ->
#     linkB.attr("x1", (d) ->
#       d.source.x
#     ).attr("y1", (d) ->
#       d.source.y
#     ).attr("x2", (d) ->
#       d.target.x
#     ).attr "y2", (d) ->
#       d.target.y

#     nodeB.attr("cx", (d) ->
#       d.x
#     ).attr "cy", (d) ->
#       d.y



