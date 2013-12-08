width = 400
height = 400
history = [] #Graphs that already exist on the page
years = []

socket = io.connect("http://localhost:3000")
$("#submit").on "click", (event) ->
  event.preventDefault()
  $("#loading").attr("style", style="visibility: visible;")
  $("#diverged").attr("style", style="visibility: hidden;")
  socket.emit "search",
    A: $("#searchA").val()
    B: $("#searchB").val()

set_nodes = []
csv_data = ['Order, Family, Genus, Species']
socket.on "csv_callback", (data) ->
  curves.call(true)
  #console.log data
  #console.log data
  #console.log $.isEmptyObject(data)
  if $.isEmptyObject(data) == false and $.isArray(data) == false
    console.log data
    set_nodes.push data
    #years.push data[1]
    console.log set_nodes
    #console.log years
    vis.datum(set_nodes).call chart
    #$("#timeline").datum(years).call chart
  else if $.isEmptyObject(data)
   console.log "WolframAlpha couldn't find a taxonomy for one of the organisms."
  #console.log set_nodes
  #svg = d3.select("#parallel_sets")#.transition()
  #console.log svg
  #csv_data.push data
  #console.log csv_data

socket.on "callback", (data) ->
  #console.log data
  if data[2]  == null
    $("#loading").attr("style", style="visibility: hidden;")
    #alert('I apologize, no results found!\n\nTry using the scientific names for organisms!')
  else
    $("#loading").attr("style", style="visibility: hidden;")
    $("#diverged").attr("style", style="visibility: visible;")
    $("#info").html("diverged " + data[2])
    
    if $.inArray(data[0],history) == -1
      history.push data[0]
      #year = data[2].match(/^(?:[1-9]\d*|0)?(?:\.\d+)?/);
      #console.log typeof(parseFloat(year))   
      #years.push parseFloat(year)
      #Update timeline chart. Add circle to it
      #Width and height
  #     xScale = d3.scale.linear().domain([0, 3000]).range([padding, w - padding * 2])
  # # # #xScale = d3.scale.ordinal().domain(['2013CE', '500M', '1000M', '1500M', '2000M', '2500M', '3000M']).range([padding, w - padding * 2])
  #     yScale = d3.scale.linear().domain([0, d3.max(years, (d) ->
  #       d[0]
  #     )]).range([h - padding, padding])
  #     rScale = d3.scale.linear().domain([0, d3.max(years, (d) ->
  #       d[0]
  #     )]).range([0, 5])
  # # # #Define X axis
  #     xAxis = d3.svg.axis().scale(xScale).tickSize(0).orient("bottom").tickFormat (d) ->
  #       d + " M"
  # # #Create SVG element
  #     timeline = d3.select("#timeline")
  #     h = 50
  #     w = 990
  #     padding = 30
  #     timeline.append("g").attr("class", "axis").attr("transform", "translate(0," + (h - padding) + ")").call xAxis
  # #Create circles
      # timeline.selectAll("circle").data(years).enter().append("circle").attr("class", "circle").attr("cx", (d) ->
      #   xScale d[0]
      # ).attr("cy", (d) ->
      #   yScale 0
      # ).attr "r", (d) ->
      #   rScale 5 * 2
    #   #Graph A
    #   d3.select "svg"
    #   color = d3.scale.category20()
    #   force = d3.layout.force().charge(-120).linkDistance(30).size([width, height])
    #   scale = 1.0
      
    #   #The left graph
    #   svgA = d3.select("#graph-left").append("svg").attr("viewBox", "0 0 " + width * scale + " " + height * scale + "").attr("width", width).attr("height", height).attr("preserveAspectRatio", "none")
    #   graphA = $.parseJSON(data[0])
    #   console.log graphA
    #   force.nodes(graphA.nodes).links(graphA.links).start()
    #   link = svgA.selectAll(".link").data(graphA.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
    #     Math.sqrt d.value
    #   )
    #   node = svgA.selectAll(".node").data(graphA.nodes).enter().append("circle").attr("class", "node").attr("r", 10).style("fill", (d) ->
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

    # if $.inArray(data[1],history) == -1
    #   history.push data[1]

    #   #Graph B
    #   color = d3.scale.category20()
    #   forceB = d3.layout.force().charge(-120).linkDistance(30).size([width, height])
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
    #   nodeB = svgB.selectAll(".node").data(graphB.nodes).enter().append("circle").attr("class", "node").attr("r", 10).style("fill", (d) ->
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

#stuff = [{"Order": "Primates", "Family": "Hominidae", "Genus": "Homo", "Species": "HomoSapiens"}, {"Order": "Primates", "Family": "Hominidae", "Genus": "Homo", "Species": "Test"}]
stuff = set_nodes
curves = ->
  t = vis.transition().duration(500)
  if ice
    t.delay 1000
    icicle()
  #t.call chart.tension((if @checked then .5 else 1))
  t.call chart.tension(.5)
iceTransition = (g) ->
  g.transition().duration 1000
ribbonPath = (s, t, tension) ->
  sx = s.node.x0 + s.x0
  tx = t.node.x0 + t.x0
  sy = s.dimension.y0
  ty = t.dimension.y0
  ((if tension is 1 then ["M", [sx, sy], "L", [tx, ty], "h", t.dx, "L", [sx + s.dx, sy], "Z"] else ["M", [sx, sy], "C", [sx, m0 = tension * sy + (1 - tension) * ty], " ", [tx, m1 = tension * ty + (1 - tension) * sy], " ", [tx, ty], "h", t.dx, "C", [tx + t.dx, m1], " ", [sx + s.dx, m0], " ", [sx + s.dx, sy], "Z"])).join ""
stopClick = ->
  d3.event.stopPropagation()

# Given a text function and width function, truncates the text if necessary to
# fit within the given width.
truncateText = (text, width) ->
  (d, i) ->
    t = @textContent = text(d, i)
    w = width(d, i)
    return t  if @getComputedTextLength() < w
    @textContent = "…" + t
    lo = 0
    hi = t.length + 1
    x = undefined
    while lo < hi
      mid = lo + hi >> 1
      if (x = @getSubStringLength(0, mid)) < w
        lo = mid + 1
      else
        hi = mid
    (if lo > 1 then t.substr(0, lo - 2) + "…" else "")
chart = d3.parsets().dimensions(["Order","Family","Genus","Species"])
#vis = d3.select("#parallel_sets").append("svg").attr("width", chart.width()).attr("height", chart.height())
#parallel_sets_chart
vis = d3.select("#parallel_sets_chart").attr("width", chart.width()).attr("height", chart.height())
partition = d3.layout.partition().sort(null).size([chart.width(), chart.width() * 5 / 4]).children((d) ->
  (if d.children then d3.values(d.children) else null)
).value((d) ->
  d.count
)
ice = false

#d3.csv "organisms.csv", (csv) ->
vis.datum(stuff).call chart
window.icicle = ->
  newIce = @checked
  tension = chart.tension()
  return  if newIce is ice
  if ice = newIce
    dimensions = []
    vis.selectAll("g.dimension").each (d) ->
      dimensions.push d

    dimensions.sort (a, b) ->
      a.y - b.y

    root = d3.parsets.tree(
      children: {}
    , csv, dimensions.map((d) ->
      d.name
    ), ->
      1
    )
    nodes = partition(root)
    nodesByPath = {}
    nodes.forEach (d) ->
      path = d.data.name
      p = d
      path = p.data.name + "\u0000" + path  while (p = p.parent) and p.data.name
      nodesByPath[path] = d  if path

    data = []
    vis.on("mousedown.icicle", stopClick, true).select(".ribbon").selectAll("path").each (d) ->
      node = nodesByPath[d.path]
      s = d.source
      t = d.target
      s.node.x0 = t.node.x0 = 0
      s.x0 = t.x0 = node.x
      s.dx0 = s.dx
      t.dx0 = t.dx
      s.dx = t.dx = node.dx
      data.push d

    iceTransition(vis.selectAll("path")).attr("d", (d) ->
      s = d.source
      t = d.target
      ribbonPath s, t, tension
    ).style "stroke-opacity", 1
    iceTransition(vis.selectAll("text.icicle").data(data).enter().append("text").attr("class", "icicle").attr("text-anchor", "middle").attr("dy", ".3em").attr("transform", (d) ->
      "translate(" + [d.source.x0 + d.source.dx / 2, d.source.dimension.y0 + d.target.dimension.y0 >> 1] + ")rotate(90)"
    ).text((d) ->
      (if d.source.dx > 15 then d.node.name else null)
    ).style("opacity", 1e-6)).style "opacity", 1
    iceTransition(vis.selectAll("g.dimension rect, g.category").style("opacity", 1)).style("opacity", 1e-6).each "end", ->
      d3.select(this).attr "visibility", "hidden"

    iceTransition(vis.selectAll("text.dimension")).attr "transform", "translate(0,-5)"
    vis.selectAll("tspan.sort").style "visibility", "hidden"
  else
    vis.on("mousedown.icicle", null).select(".ribbon").selectAll("path").each (d) ->
      s = d.source
      t = d.target
      s.node.x0 = s.node.x
      s.x0 = s.x
      s.dx = s.dx0
      t.node.x0 = t.node.x
      t.x0 = t.x
      t.dx = t.dx0

    iceTransition(vis.selectAll("path")).attr("d", (d) ->
      s = d.source
      t = d.target
      ribbonPath s, t, tension
    ).style "stroke-opacity", null
    iceTransition(vis.selectAll("text.icicle")).style("opacity", 1e-6).remove()
    iceTransition(vis.selectAll("g.dimension rect, g.category").attr("visibility", null).style("opacity", 1e-6)).style "opacity", 1
    iceTransition(vis.selectAll("text.dimension")).attr "transform", "translate(0,-25)"
    vis.selectAll("tspan.sort").style "visibility", null

d3.select("#icicle").on("change", icicle).each icicle
# d3.select("#file").on "change", ->
#   file = @files[0]
#   reader = new FileReader
#   reader.onloadend = ->
#     csv = d3.csv.parse(reader.result)
#     vis.datum(csv).call chart.value((if csv[0].hasOwnProperty("Number") then (d) ->
#       +d.Number
#      else 1)).dimensions((d) ->
#       d3.keys(d[0]).filter((d) ->
#         d isnt "Number"
#       ).sort()
#     )

#   reader.readAsText file
