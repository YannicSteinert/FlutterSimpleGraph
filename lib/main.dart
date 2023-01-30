import 'package:flutter/material.dart';
import 'package:simplegraph/graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Center(
          child: Graph(
            width: 400,
            height: 300,
            pointdata: [
              GData(data: [0.1, 0.2, 0.3, 0.2, 0.5, 0.6, 0.7, 0.1, 0.9, 0.2, 0.11, 0.12], color: Colors.pink),
              GData(data: [1.2, 1.2, 1, 0.8, 1.1, 0.3, 0.2, -0.1, 0.4, 0.5, 0.3, 0.1], color: Colors.blue),
            ],
            backgroundColor: Colors.grey.shade200,
            style: GraphStyle(
              drawVerticalGrid: true,
              drawHorizontalGrid: true,
              drawAxis: false,
              xZero: 2,
              gridStep: 0.25,
              xAxisTextStyle: TextStyle(fontSize: 12, color: Colors.black),
              yAxisTextStyle: TextStyle(fontSize: 12, color: Colors.black),
              labels: ['Jan', 'Feb', 'Mrz', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'],
            ),
          ),
        ));
  }
}
