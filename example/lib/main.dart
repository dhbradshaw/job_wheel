import 'package:flutter/material.dart';
import 'package:job_wheel/job_wheel.dart';
import 'dart:js' as js;

void main() => runApp(WheelApp());

class WheelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FHE Wheel',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: WheelHomePage(title: 'FHE Wheel'),
    );
  }
}

class WheelHomePage extends StatefulWidget {
  WheelHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WheelHomePageState createState() => _WheelHomePageState();
}

class _WheelHomePageState extends State<WheelHomePage> {

  double _counter = 0;
  List<String> innerChoices = [];
  List<String> outerChoices = [];
  double offset = 0;

  _WheelHomePageState() : super() {
    var uri = Uri.tryParse(js.context['location']['href']);
    var params = uri.queryParameters;

    // Resolve outerChoices.
    if (params.containsKey("outerChoices")) {
      this.outerChoices = params["outerChoices"].split(",");
    } else
      this.outerChoices = [
        "Conducting",
        "Song",
        "Prayer",
        "Scripture",
        "Gratitude",
      ];

    // // Resolve innerChoices.
    if (params.containsKey("innerChoices")) {
      this.innerChoices = params["innerChoices"].split(",");
    } else
      this.innerChoices = [
        "Dad",
        "Mom",
        "John",
        "Jill",
        "Susan",
      ];

    // Resolve fixed offset
    double fixedOffset = double.parse(params["offset"] ?? "0") ?? 0;

    // Resolve temporal offset
    int temporalOffset = 0;
    if (params.containsKey("start")) {
      DateTime start = DateTime.parse(params["start"]);
      DateTime now = DateTime.now();
      Duration dt = now.difference(start);
      Duration turnLength = Duration(
        seconds: int.parse(params["turnSeconds"]) ?? 3600 * 24 * 7,
      );
      temporalOffset = dt.inMicroseconds ~/ turnLength.inMicroseconds;
    }
    this.offset = temporalOffset + fixedOffset;
  }
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JobWheel(
        number: _counter + this.offset,
        outerChoices: this.outerChoices,
        innerChoices: this.innerChoices,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Text("$_counter"),
      ),
    );
  }
}
