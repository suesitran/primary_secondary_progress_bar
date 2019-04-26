import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PrimarySecondaryProgressBar extends StatelessWidget {
  final _PrimarySecondaryProgressBarPainter _painter;

  final sliderHeight;
  final sliderWidth;

  PrimarySecondaryProgressBar(
      BuildContext context, {
        double primaryValue = 0.0,
        double primaryMax = 0.0,
        String primaryLabel = "",
        String primaryIndicatorLine1 = "",
        String primaryIndicatorLine2 = "",
        Color primaryTextColor = Colors.indigo,
        double secondaryValue = 0.0,
        double secondaryMax = 0.0,
        String secondaryLabel = "",
        Color secondaryTextColor = Colors.white,
        this.sliderWidth = 0.0,
        this.sliderHeight = 0.0,
        Color activeColor = Colors.white,
        double indicatorArrowHeight = 10.0,
        double indicatorHeight = 40.0,
        double indicatorWidth = 80.0,
      }) :_painter = _PrimarySecondaryProgressBarPainter(context,
        primaryValue: primaryValue,
        primaryMax: primaryMax,
        primaryLabel: primaryLabel,
        primaryIndicatorLine1: primaryIndicatorLine1,
        primaryIndicatorLine2: primaryIndicatorLine2,
        primaryTextColor: primaryTextColor,
        secondaryMax: secondaryMax,
        secondaryValue: secondaryValue,
        secondaryLabel: secondaryLabel,
        secondaryTextColor: secondaryTextColor,
        activeColor: activeColor,
        indicatorArrowHeight: indicatorArrowHeight,
        indicatorHeight: indicatorHeight,
        indicatorWidth: indicatorWidth);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraint) => CustomPaint(
          size: constraint.biggest,
          painter: _painter
            ..setSliderHeight(sliderHeight == 0.0 ? 50 : sliderHeight)
            ..setSliderWidth(sliderWidth == 0.0 ? constraint.maxWidth : sliderWidth),)
    );
  }
}

class _PrimarySecondaryProgressBarPainter extends CustomPainter {
  final BuildContext context;

  // primary bar
  final double primaryValue;
  final double primaryMax;
  final String primaryLabel;
  final String primaryIndicatorLine1;
  final String primaryIndicatorLine2;

  final double secondaryValue;
  final double secondaryMax;
  final String secondaryLabel;

  Color inactiveColor;
  final Color activeColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final indicatorWidth;
  final indicatorHeight;
  final indicatorArrowHeight;

  var _sliderHeight;
  var _sliderWidth;

  _PrimarySecondaryProgressBarPainter(this.context,
      {this.primaryValue,
        this.primaryMax,
        this.primaryLabel,
        this.primaryIndicatorLine1,
        this.primaryIndicatorLine2,
        this.primaryTextColor,
        this.secondaryValue,
        this.secondaryMax,
        this.secondaryLabel,
        this.secondaryTextColor,
        this.activeColor,
        this.indicatorWidth,
        this.indicatorHeight,
        this.indicatorArrowHeight}) {
    inactiveColor = activeColor.withOpacity(0.7);
  }

  void setSliderHeight(double height) => this._sliderHeight = height;
  void setSliderWidth(double width) => this._sliderWidth = width;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    var top = (size.height - _sliderHeight) / 2;
    var bottom = top + _sliderHeight;
    var fontSize = Theme.of(context).textTheme.title.fontSize;

    var sliderRect = ui.Rect.fromLTRB(0, top, _sliderWidth, bottom);

    _drawSecondaryIndicator(canvas, size, sliderRect);
    _drawSlider(canvas, size, sliderRect, fontSize);
  }

  void _drawSlider(ui.Canvas canvas, ui.Size size, ui.Rect sliderRect, double fontSize) {
    var progressRatio = primaryMax == 0 ? 0 : primaryValue / primaryMax;

    // draw slider
    ui.Paint sliderBackground = new ui.Paint()
      ..color = inactiveColor
      ..strokeCap = ui.StrokeCap.round
      ..style = ui.PaintingStyle.fill
      ..isAntiAlias = true;
    ui.Paint sliderProgress = new ui.Paint()
      ..color = activeColor
      ..strokeCap = ui.StrokeCap.round
      ..style = ui.PaintingStyle.fill
      ..isAntiAlias = true;
    final progressRadius = ui.Radius.circular(10.0);

    canvas.drawRRect(ui.RRect.fromRectAndRadius(sliderRect, progressRadius), sliderBackground);

    var progressWidth = sliderRect.width * progressRatio;
    canvas.drawRRect(ui.RRect.fromRectAndRadius(ui.Rect.fromLTRB(sliderRect.left, sliderRect.top, progressWidth, sliderRect.bottom), progressRadius), sliderProgress);

    // draw primary label => max primary
    drawText(canvas, primaryLabel, sliderRect, primaryTextColor, ui.TextAlign.right);

    // draw expenses indicator
    final arrowWidth = indicatorWidth / 4;

    // define arrow point offsets
    var arrowCenter = progressWidth;
    var arrowLeft = arrowCenter - arrowWidth/2;
    var arrowRight = arrowCenter + arrowWidth/2;

    var indicatorLeft = progressWidth - indicatorWidth / 2;
    if(indicatorLeft <= 0) {
      // adjust bubble when bubble is overlapping left corner
      if(progressWidth < arrowWidth/2) {
        indicatorLeft = progressWidth;
      }
      else {
        indicatorLeft = 0;
      }
      arrowLeft = progressWidth;
    }
    var indicatorRight = indicatorLeft + indicatorWidth;
    if(indicatorRight >= size.width) {
      // adjust bubble when bubble is overlapping right conner
      if(progressWidth + indicatorWidth >= size.width) {
        indicatorRight = progressWidth;
        indicatorLeft = size.width - indicatorWidth;
        arrowRight = arrowCenter;
      } else {
        indicatorRight = size.width - arrowWidth/2;
        arrowRight = arrowCenter;
      }
      indicatorLeft = indicatorRight - indicatorWidth;
    }
    var indicatorBottom = sliderRect.top - indicatorArrowHeight;
    var indicatorTop = indicatorBottom - indicatorHeight;

    final indicatorRect = ui.Rect.fromLTRB(indicatorLeft, indicatorTop, indicatorRight, indicatorBottom);
    canvas.drawRRect(ui.RRect.fromRectAndRadius(indicatorRect, progressRadius), sliderProgress);

    // create little arrow path
    ui.Path path = new ui.Path()
      ..moveTo(arrowLeft, indicatorBottom - indicatorHeight/2)
      ..lineTo(arrowLeft, indicatorBottom)
      ..lineTo(arrowCenter, indicatorBottom + indicatorArrowHeight)
      ..lineTo(arrowRight, indicatorBottom)
      ..lineTo(arrowRight, indicatorBottom - indicatorHeight/2);
    canvas.drawPath(path, sliderProgress);

    // draw primary indicator string
    if (primaryIndicatorLine2 == null || primaryIndicatorLine2.isEmpty) {
      drawText(canvas, primaryIndicatorLine1, indicatorRect, primaryTextColor, ui.TextAlign.center);
    } else {
      draw2LinesText(
          canvas,
          primaryIndicatorLine1,
          primaryIndicatorLine2,
          indicatorRect,
          primaryTextColor,
          ui.TextAlign.center,
          fontSize);
    }
  }

  void _drawSecondaryIndicator(ui.Canvas canvas, ui.Size size, ui.Rect sliderRect) {
    final secondaryTextWidth = 120.0;
    final secondaryTextMarginTop = 10.0;

    ui.Paint dayIndicator = new ui.Paint()
      ..color = activeColor
      ..strokeCap = ui.StrokeCap.round
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..isAntiAlias = true;

    var daysRatio = secondaryMax > 0 ? secondaryValue / secondaryMax : 0;
    var indicatorPosition = daysRatio * sliderRect.width;
    canvas.drawLine(ui.Offset(indicatorPosition, sliderRect.top - secondaryTextMarginTop), ui.Offset(indicatorPosition, sliderRect.bottom + secondaryTextMarginTop), dayIndicator);

    var textAlign = ui.TextAlign.center;
    var textLeft = indicatorPosition - secondaryTextWidth/2;
    if(textLeft + secondaryTextWidth/2 <= 0) {
      textLeft = 0.0;
      textAlign = ui.TextAlign.start;
    }
    var textRight = textLeft + secondaryTextWidth;
    if(textRight - secondaryTextWidth/2 >= size.width) {
      textRight = size.width;
      textAlign = ui.TextAlign.end;
      textLeft = textRight - secondaryTextWidth;
    }
    final textTop = sliderRect.bottom + secondaryTextMarginTop;
    final textBottom = sliderRect.bottom + 2*secondaryTextMarginTop;

    final textRect = ui.Rect.fromLTRB(
        textLeft,
        textTop,
        textRight,
        textBottom);
    drawText(canvas, secondaryLabel, textRect, secondaryTextColor, textAlign);
  }

  void drawText(ui.Canvas canvas, String text, ui.Rect boundary, Color color, ui.TextAlign textAlign) {
    final textPainter = new Paint()..color = color;

    final ui.Size size = boundary.size;

    final paragraphStyle = new ui.ParagraphStyle(
      textAlign: textAlign,
    );
    final paragraphBuilder = new ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(new ui.TextStyle(foreground: textPainter))
      ..addText(text);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(new ui.ParagraphConstraints(width: size.width / 2));

    var dx = 0.0;
    var dy = 0.0;

    switch (textAlign) {
      case ui.TextAlign.center:
        dx = size.width * 0.25;
        dy = size.height * 0.33;
        break;
      case ui.TextAlign.right:
      case ui.TextAlign.end:
        dx = size.width * 0.48;
        dy = size.height * 0.33;
        break;
      case ui.TextAlign.left:
      case ui.TextAlign.start:
      case ui.TextAlign.justify:
        dx = 0.0;
        dy = size.height * 0.33;
        break;
    }

    ui.Offset offset = new ui.Offset(dx, dy);

    canvas.save();
    canvas.translate(boundary.left, boundary.top);
    canvas.drawParagraph(paragraph, offset);
    canvas.restore();
  }

  void draw2LinesText(ui.Canvas canvas, String firstLineText, String secondLineText, ui.Rect boundary, ui.Color color, ui.TextAlign textAlign, double fontSize) {
    final textPainter = new ui.Paint()..color = color;

    final ui.Size size = boundary.size;

    final paragraphStyle = new ui.ParagraphStyle(
      textAlign: textAlign,
    );
    final primaryParagraphBuilder = new ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(new ui.TextStyle(foreground: textPainter, fontSize: fontSize))
      ..addText(firstLineText);
    final primaryParagraph = primaryParagraphBuilder.build();
    primaryParagraph.layout(new ui.ParagraphConstraints(width: size.width));

    final secondaryParagraphBuilder = new ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(new ui.TextStyle(foreground: textPainter, fontSize: fontSize * 0.6))
      ..addText(secondLineText);
    final secondaryParagraph = secondaryParagraphBuilder.build();
    secondaryParagraph.layout(new ui.ParagraphConstraints(width: size.width));

    ui.Offset primaryLine = new ui.Offset(0.0, size.height * 0.05);
    ui.Offset secondaryLine = new ui.Offset(0.0, size.height * 0.6);

    canvas.save();
    canvas.translate(boundary.left, boundary.top);
    canvas.drawParagraph(primaryParagraph, primaryLine);
    canvas.drawParagraph(secondaryParagraph, secondaryLine);
    canvas.restore();
  }
}