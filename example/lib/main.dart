import 'package:flutter/material.dart';
import 'package:primary_secondary_progress_bar/primary_secondary_progress_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _PrimarySecondaryExample(),
    );
  }
}

class _PrimarySecondaryExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Bar Example'),
      ),
      body: Card(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimarySecondaryProgressBar(
            context,
            primaryLabel: "100%",
            primaryMax: 100.0,
            primaryValue: 70.0,
            secondaryValue: 28,
            secondaryMax: 30,
            secondaryLabel: "23 days",
            primaryIndicatorLine1: "30%",
            primaryIndicatorLine2: "more",),
        ),
      )
    );
  }
}
