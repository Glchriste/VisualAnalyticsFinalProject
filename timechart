timechart = (svg, data, height, width, padding) ->
  h = height
  w = width
  w = 990
  h = 50
  padding = 30
  #years.push parseFloat(year[0])
  xScale = d3.scale.linear().domain([0, 3000]).range([padding, w - padding * 2])
  yScale = d3.scale.linear().domain([0, d3.max(data, (d) ->
    d[0]
  )]).range([h-padding,padding])
  rScale = d3.scale.linear().domain([0, d3.max(data, (d) ->
    d[0]
  )]).range([0,5])
  #Define X Axis
  xAxis = d3.svg.axis().scale(xScale).tickSize(0).orient("bottom").tickFormat (d) ->
    d + " M"
  #Get svg element
  #timeline = d3.select("#timeline")
  #h = 50
  #w = 990
  #padding = 30
  svg.append("g").attr("class", "axis").attr("transform", "translate(0," + (h - padding) + ")").call xAxis
  #Create circles
  svg.selectAll("circle").data(years).enter().append("circle").attr("class", "circle").attr("cx", (d) ->
    xScale d
  ).attr("cy", (d) ->
    yScale 0
  ).attr "r", (d) ->
    rScale 10 
  console.log 'Added circle'
  svg.datum(data).call chart