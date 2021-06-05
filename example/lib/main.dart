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

class _PrimarySecondaryExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrimarySecondaryExampleState();
  }
}

class _PrimarySecondaryExampleState extends State<_PrimarySecondaryExample> {

  final _primaryMax = 100.0;
  double _primaryValue = 0.0;

  final _secondaryMax = 30.0;
  double _secondaryValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Progress Bar Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              color: Colors.indigo,
              borderOnForeground: true,
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(8.0),
                child: PrimarySecondaryProgressBar(
                  context,
                  primaryLabel: "${_primaryMax.round()}%",
                  primaryMax: _primaryMax,
                  primaryValue: _primaryValue,
                  secondaryValue: _secondaryValue,
                  secondaryMax: _secondaryMax,
                  secondaryLabel: "${_secondaryValue.round()} days",
                  primaryIndicatorLine1: "${(_primaryMax - _primaryValue).round()}%",
                  primaryIndicatorLine2: "more",
                ),
              ),
            ),
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Primary Value", style: Theme.of(context).textTheme.bodyText2,),
                  Slider(
                    value: _primaryValue,
                    min: 0,
                    max: _primaryMax,
                    onChanged: (value) => setState(() => _primaryValue = value),
                  ),
                  Text("Secondary value", style: Theme.of(context).textTheme.bodyText2,),
                  Slider(
                    value: _secondaryValue,
                    min: 0.0,
                    max: _secondaryMax,
                    onChanged: (value) => setState(() => _secondaryValue = value),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
