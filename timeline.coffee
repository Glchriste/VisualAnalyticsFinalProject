#Width and height
w = 990
h = 50
padding = 30
dataset = [[2535.8,5, "Humans vs. Bacteria"]]

#Create scale functions
# xScale = d3.scale.linear().domain([0, d3.max(dataset, (d) ->
#   d[0]
# )]).range([padding, w - padding * 2])
xScale = d3.scale.linear().domain([0, 3000]).range([padding, w - padding * 2])
#xScale = d3.scale.ordinal().domain(['2013CE', '500M', '1000M', '1500M', '2000M', '2500M', '3000M']).range([padding, w - padding * 2])
yScale = d3.scale.linear().domain([0, d3.max(dataset, (d) ->
  d[1]
)]).range([h - padding, padding])
rScale = d3.scale.linear().domain([0, d3.max(dataset, (d) ->
  d[1]
)]).range([0, 5])

#Define X axis
xAxis = d3.svg.axis().scale(xScale).tickSize(0).orient("bottom").tickFormat (d) ->
  d + " M"

#Create SVG element
svg = d3.select("#timeline").attr("width", w).attr("height", h)

svg.append("g").attr("class", "axis").attr("transform", "translate(0," + (h - padding) + ")").call xAxis

#Create circles
svg.selectAll("circle").data(dataset).enter().append("circle").attr("class", "circle").attr("cx", (d) ->
  xScale d[0]
).attr("cy", (d) ->
  yScale 0
).attr "r", (d) ->
  rScale d[1] * 2


# #Create labels
# svg.selectAll("text").data(dataset).enter().append("text").text((d) ->
#   d[0] + "," + d[1]
# ).attr("x", (d) ->
#   xScale d[0]
# ).attr("y", (d) ->
#   yScale d[1]
# ).attr("font-family", "sans-serif").attr("font-size", "11px").attr "fill", "red"

#Create X axis

svg.append("g").on("mouseover", ->
  d3.select(this).classed "hover", true
  ).on "mouseout", ->
  d3.select(this).classed "hover", false
