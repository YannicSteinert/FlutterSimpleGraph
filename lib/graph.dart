import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GData {
  GData({@required this.data, this.title = '', this.color = Colors.black});

  List<double>? data;
  String title;
  Color color;
}

class GraphStyle {
  GraphStyle({
    this.drawHorizontalGrid = true,
    this.drawVerticalGrid = true,
    this.drawAxis = true,
    this.gridColor = Colors.grey,
    this.yMin = 0,
    this.yMax = 0,
    this.xZero = 0,
    this.xAxisTextStyle = null,
    this.yAxisTextStyle = null,
    this.inset = 0,
    this.labels = null,
    this.gridStep = 1,
  });

  bool drawHorizontalGrid, drawVerticalGrid, drawAxis;
  Color gridColor;
  double yMin, yMax, xZero, inset, gridStep;

  TextStyle? xAxisTextStyle, yAxisTextStyle;
  List<String>? labels;
}

class Graph extends StatefulWidget {
  Graph({
    // widget specific
    @required this.width,
    @required this.height,
    @required this.pointdata,
    this.backgroundColor = Colors.white,

    // graph specific
    this.style,
  });

  _GraphPainter? _painter;

  // Widget
  double? width, height;
  Color backgroundColor;

  // Graph Grid
  GraphStyle? style;

  // Data
  List<GData>? pointdata;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        size: Size(700, 300),
        painter: _GraphPainter(
          widget.pointdata!,
          widget.style == null ? GraphStyle() : widget.style!,
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter(this.data, this.style);

  List<GData> data;
  GraphStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    double verticalScale = 0, horizontalScale = 0, verticalOffset = 0;

    double yStepSize = 0;

    Size actualSize =
    Size(size.width - (style.inset * 2), size.height - (style.inset * 2));
    double xPadding = style.inset, yPadding = style.inset;
    {
      // size needed for axis text
      if (style.xAxisTextStyle != null) {}
      if (style.yAxisTextStyle != null) {}

      // scope just for dataLength and shouldAutoScale
      double dataLength = 0;
      bool shouldAutoScale = (style.yMax == style.yMin && style.yMin == 0);

      data.forEach((element) {
        if (element.data != null) {
          // auto scale
          if (shouldAutoScale) {
            element.data!.forEach((v) {
              // search for highest and lowest value in this.data
              if (v > style.yMax) style.yMax = v; // new max
              if (v < style.yMin) style.yMin = v; // new min
            });
          }
          // horizontal scale
          if (element.data!.length.toDouble() - 1 > dataLength)
            dataLength = element.data!.length.toDouble() - 1;
        }
      });

      // y-Padding if X-Axis Label shown
      if (style.xAxisTextStyle != null) {
        double longestLabel = 0;
        style.labels!.forEach((element) {
          if (element != null) {
            if (element.length > longestLabel)
              longestLabel = element.length.toDouble();
          }
        });
        xPadding = xPadding +
            (style.xAxisTextStyle!.fontSize!.toDouble() * longestLabel / 2);
        actualSize = Size(
            actualSize.width -
                (style.xAxisTextStyle!.fontSize!.toDouble() * longestLabel),
            actualSize.height);

        yPadding = yPadding + style.xAxisTextStyle!.fontSize!.toDouble();
        actualSize = Size(
            actualSize.width,
            actualSize.height -
                (style.xAxisTextStyle!.fontSize!.toDouble() * 4));
      }
      // y-Padding if X-Axis Label shown
      if (style.yAxisTextStyle != null) {
        double longestLabel = 0;
        style.labels!.forEach((element) {
          if (element != null) {
            if (element.length > longestLabel)
              longestLabel = element.length.toDouble();
          }
        });
        xPadding = xPadding + (style.xAxisTextStyle!.fontSize!.toDouble() * longestLabel / 2);
        xPadding = xPadding - style.xAxisTextStyle!.fontSize!.toDouble() / 2;
        actualSize = Size(actualSize.width - (style.xAxisTextStyle!.fontSize!.toDouble() * longestLabel), actualSize.height);
      }

      // determine vertical scale
      verticalScale = actualSize.height / (style.yMax - style.yMin);
      horizontalScale = actualSize.width / dataLength;
      // vertical offset
      if (style.yMin < 0) verticalOffset = -style.yMin;
    }

    // draw background grid
    if (style.drawHorizontalGrid)
      for (double i = style.yMin.round().toDouble();
      i < style.yMax;
      i += style.gridStep) {
        List<Offset> points = [];
        double y = actualSize.height - ((i + verticalOffset) * verticalScale);
        points.add(Offset(xPadding, y + yPadding));
        points.add(Offset(actualSize.width + xPadding, y + yPadding));

        final paint = Paint()
          ..color = style.gridColor
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
        canvas.drawPoints(ui.PointMode.polygon, points, paint);
      }
    if (style.drawVerticalGrid)
      for (int i = 0; i < actualSize.width / horizontalScale; i++) {
        List<Offset> points = [];
        double x = i * horizontalScale;
        points.add(Offset(x + xPadding, yPadding));
        points.add(Offset(x + xPadding, actualSize.height + yPadding));

        final paint = Paint()
          ..color = style.gridColor
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
        canvas.drawPoints(ui.PointMode.polygon, points, paint);
      }
    // draw axis
    if (style.drawAxis) {
      List<Offset> points = [];
      points.add(Offset((style.xZero * horizontalScale) + xPadding, yPadding));
      points.add(Offset((style.xZero * horizontalScale) + xPadding,
          actualSize.height + yPadding));

      points.add(Offset(xPadding + (style.xZero * horizontalScale),
          yPadding + (actualSize.height - (verticalOffset * verticalScale))));
      points.add(Offset(xPadding,
          yPadding + (actualSize.height - (verticalOffset * verticalScale))));
      points.add(Offset(xPadding + actualSize.width,
          yPadding + (actualSize.height - (verticalOffset * verticalScale))));

      final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(ui.PointMode.polygon, points, paint);
    }

    // draw X-Axis labels
    if (style.xAxisTextStyle != null) {
      if (style.labels != null) {
        for (int i = 0; i < style.labels!.length; i++) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: style.labels![i],
              style: style.xAxisTextStyle!,
            ),
            textDirection: TextDirection.rtl,
          );
          textPainter.layout(
            minWidth: 0,
            maxWidth: size.width,
          );

          double x = xPadding + (i * horizontalScale);
          x -= style.labels!.length *
              style.xAxisTextStyle!.fontSize!.toDouble() /
              16;
          double y = actualSize.height +
              (2 * style.xAxisTextStyle!.fontSize!.toDouble());
          textPainter.paint(canvas, Offset(x, y));
        }
      }
    }
    // draw Y-Axis labels
    if (style.yAxisTextStyle != null)
      for (double i = style.yMin.round().toDouble();
      i < style.yMax;
      i += style.gridStep) {
        double x =
            (i.toString().length * style.yAxisTextStyle!.fontSize!.toDouble()) /
                2;
        x += style.yAxisTextStyle!.fontSize!.toDouble() / 2;
        double y = actualSize.height - ((i + verticalOffset) * verticalScale);
        y = y - (style.yAxisTextStyle!.fontSize!.toDouble() / 2);

        final textPainter = TextPainter(
          text: TextSpan(
            text: i.toString(),
            style: style.xAxisTextStyle!,
          ),
          textDirection: TextDirection.rtl,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );

        textPainter.paint(canvas, Offset(xPadding - x, y + yPadding));
      }

    // draw graphs
    data.forEach((element) {
      if (element.data != null) {
        List<Offset> points = [];
        for (int i = 0; i < element.data!.length; i++) {
          double x = i * horizontalScale;
          double y = actualSize.height -
              ((element.data![i] + verticalOffset) * verticalScale);

          points.add(Offset(x + xPadding, y + yPadding));
        }
        final paint = Paint()
          ..color = element.color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
        canvas.drawPoints(ui.PointMode.polygon, points, paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
