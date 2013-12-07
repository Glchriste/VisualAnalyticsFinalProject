curves = ->
  t = vis.transition().duration(500)
  if ice
    t.delay 1000
    icicle()
  t.call chart.tension((if @checked then .5 else 1))
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
chart = d3.parsets().dimensions(["Survived", "Sex", "Age", "Class"])
vis = d3.select("#vis").append("svg").attr("width", chart.width()).attr("height", chart.height())
partition = d3.layout.partition().sort(null).size([chart.width(), chart.height() * 5 / 4]).children((d) ->
  (if d.children then d3.values(d.children) else null)
).value((d) ->
  d.count
)
ice = false
d3.csv "titanic.csv", (csv) ->
  vis.datum(csv).call chart
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

d3.select("#file").on "change", ->
  file = @files[0]
  reader = new FileReader
  reader.onloadend = ->
    csv = d3.csv.parse(reader.result)
    vis.datum(csv).call chart.value((if csv[0].hasOwnProperty("Number") then (d) ->
      +d.Number
     else 1)).dimensions((d) ->
      d3.keys(d[0]).filter((d) ->
        d isnt "Number"
      ).sort()
    )

  reader.readAsText file
