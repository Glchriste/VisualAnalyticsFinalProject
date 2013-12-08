var chart, randomData;

randomData = function(groups, points) {
  var data, i, j, random, shapes;
  data = [];
  shapes = ["circle", "cross", "triangle-up", "triangle-down", "diamond", "square"];
  random = d3.random.normal();
  i = 0;
  while (i < groups) {
    data.push({
      key: "Group " + i,
      values: []
    });
    j = 0;
    while (j < points) {
      data[i].values.push({
        x: Math.floor((Math.random() * 3000) + 1),
        y: random(),
        size: Math.random()
      });
      j++;
    }
    i++;
  }
  return data;
};

chart = void 0;

nv.addGraph(function() {
  chart = nv.models.scatterChart().showDistX(true).showDistY(true).useVoronoi(true).color(d3.scale.category10().range()).transitionDuration(300);
  chart.xAxis.tickFormat(d3.format(".02f"));
  chart.yAxis.tickFormat(d3.format(".02f"));
  chart.tooltipContent(function(key) {
    return "<h2>" + key + "</h2>";
  });
  d3.select("#divergence-chart").datum(randomData(4, 40)).call(chart);
  nv.utils.windowResize(chart.update);
  chart.dispatch.on("stateChange", function(e) {
    "New State:";
    return JSON.stringify(e);
  });
  return chart;
});
