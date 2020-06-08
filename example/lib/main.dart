import 'package:flutter/material.dart';
import 'package:job_wheel/job_wheel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

void main() => runApp(WheelApp());

class WheelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WheelHomePage();
  }
}

class WheelHomePage extends StatefulWidget {
  WheelHomePage({Key key}) : super(key: key);
  @override
  _WheelHomePageState createState() => _WheelHomePageState();
}

class _WheelHomePageState extends State<WheelHomePage> {
  double _counter = 0;
  List<String> innerChoices = [];
  List<String> outerChoices = [];
  double offset = 0;
  String title = "Job Wheel";

  _WheelHomePageState() : super() {
    var uri = Uri.tryParse(js.context['location']['href']);
    var params = uri.queryParameters;

    // Resolve outerChoices.
    if (params.containsKey("outerChoices")) {
      this.outerChoices = params["outerChoices"].split(",");
    }

    // Resolve title.
    if (params.containsKey("title")) {
      this.title = params["title"];
    }

    // Resolve innerChoices.
    if (params.containsKey("innerChoices")) {
      this.innerChoices = params["innerChoices"].split(",");
    }

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
    var body;
    if (this.innerChoices.length < 0 && this.outerChoices.length > 0) {
      body = JobWheel(
        number: _counter + this.offset,
        outerChoices: this.outerChoices,
        innerChoices: this.innerChoices,
      );
    } else {
      body = WheelForm();
    }

    return MaterialApp(
      title: this.title,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        body: body,
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Text("$_counter"),
        ),
      ),
    );
  }
}

class WheelForm extends StatefulWidget {
  @override
  _WheelFormState createState() {
    return _WheelFormState();
  }
}

class _WheelFormState extends State<WheelForm> {
  final _formKey = GlobalKey<FormState>();
  final innerChoicesController = TextEditingController();
  final outerChoicesController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    innerChoicesController.dispose();
    outerChoicesController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                // initialValue: 'laundry,cooking,trash',
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Enter title.  For example, Weekly Chores'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter outer choices';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: innerChoicesController,
                decoration: InputDecoration(
                    labelText:
                        'Enter inner choices.  For example, Dad,Mom,Steph'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter inner choices';
                  }
                  return null;
                },
              ),
              TextFormField(
                // initialValue: 'laundry,cooking,trash',
                controller: outerChoicesController,
                decoration: InputDecoration(
                    labelText:
                        'Enter outer choices.  For example, Laundry,Dishes,Trashes'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter outer choices';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(outerChoicesController.text)));
                  }
                  _launchURL(innerChoicesController.text,
                      outerChoicesController.text, titleController.text);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ));
  }
}

_launchURL(String innerChoices, String outerChoices, String title) async {
  String url =
      'https://fhe-wheel.surge.sh?title=$title&outerChoices=$innerChoices&innerChoices=$outerChoices';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
