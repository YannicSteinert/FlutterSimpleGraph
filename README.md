# simplegraph

A module for creating simple line graphs.

## How to use

Widget provided by this addon is the Graph-Widget. The parameters `width`, `height` and `pointdata` are required.
`Pointdata` is a `GData`-object containing the points, label and color of a given graph.

```dart
Graph({
    @required this.width,
    @required this.height,
    @required this.pointdata,   // the graphs data   
    this.backgroundColor,
    this.style,                 // GraphStyle object
});

class GData {
  GData({
    @required this.data,        // List<double> points
    this.title,                 // title
    this.color                  // line color
  });
}
```

To determine the style of a graph you can use the `style`-parameter.
```dart
GraphStyle({
    this.drawHorizontalGrid,      // if the background grid should be drawn
    this.drawVerticalGrid,
    this.drawAxis,                // should the axis be drawn (bolder and black)
    this.gridColor = Colors.grey, // background-grid color
    this.yMin,                    // vertical scale of the graph
    this.yMax,                    // if yMin & yMax = 0 the vertical scale is determined automatically
    this.xZero,                   // the index of the Zero value
    this.xAxisTextStyle,          // left empty the label wont be shown
    this.yAxisTextStyle,
    this.inset,                   // padding around the graph
    this.labels,                  // x-axis labels
    this.gridStep,                // vertical step size
  });
```
