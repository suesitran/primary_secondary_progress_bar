# primary_secondary_progress_bar
Primary secondary progress bar, display 2 progress info in 1 progress bar

<img src="https://github.com/suesitran/primary_secondary_progress_bar/blob/master/image/primary_secondary_example.gif" width="400">

## Installation
Add primary_secondary_progress_bar as [dependencies into your pubspec.yaml](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Example
```
Container(
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
              )
```
