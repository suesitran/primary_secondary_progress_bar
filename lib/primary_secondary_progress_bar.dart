import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as Math;

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
    TextPainter sliderPainter = new TextPainter(
      text: TextSpan(text: primaryLabel, style: TextStyle(color: primaryTextColor)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
      maxLines: 1
    );
    final sliderTextRect = Rect.fromLTRB(sliderRect.left + 5, sliderRect.top, sliderRect.right - 5, sliderRect.bottom);
    sliderPainter.layout(maxWidth: sliderTextRect.width);
    drawText(canvas, sliderTextRect, sliderPainter, textAlign: TextAlign.right);

    // draw expenses indicator
    final arrowWidth = indicatorWidth / 4;

    // define arrow point offsets
    var arrowCenter = progressWidth;
    var arrowLeft = arrowCenter - arrowWidth/2;
    var arrowRight = arrowCenter + arrowWidth/2;

    // calculate actual indicatorWidth base on text width, and use this indicator width to draw
    final line1Painter = new TextPainter(
        text: TextSpan(text: primaryIndicatorLine1,
            style: TextStyle(fontSize: fontSize, color: primaryTextColor)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1)
        ..layout(minWidth: indicatorWidth);
    final line2Painter = new TextPainter(
        text: TextSpan(text: primaryIndicatorLine2,
            style: TextStyle(fontSize: fontSize * 0.6, color: primaryTextColor)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1)
        ..layout(minWidth: indicatorWidth);

    var actualIndicatorWidth = Math.max(line1Painter.width, line2Painter.width) + 5 /* padding left */ + 5 /* padding right*/;

    var indicatorLeft = progressWidth - actualIndicatorWidth / 2;
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
    var indicatorRight = indicatorLeft + actualIndicatorWidth;
    if(indicatorRight >= size.width) {
      // adjust bubble when bubble is overlapping right conner
      if(progressWidth + actualIndicatorWidth >= size.width) {
        indicatorRight = progressWidth;
        indicatorLeft = size.width - actualIndicatorWidth;
        arrowRight = arrowCenter;
      } else {
        indicatorRight = size.width - arrowWidth/2;
        arrowRight = arrowCenter;
      }
      indicatorLeft = indicatorRight - actualIndicatorWidth;
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
      drawText(canvas, indicatorRect, line1Painter);
    } else {
      draw2LinesText(
          canvas,
          indicatorRect,
          line1Painter,
          line2Painter
      );
    }
  }

  void _drawSecondaryIndicator(ui.Canvas canvas, ui.Size size, ui.Rect sliderRect) {
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

    final textPainter = new TextPainter(
        text: TextSpan(
            text: secondaryLabel,
            style: TextStyle(color: secondaryTextColor)
        ),
        textDirection: TextDirection.ltr,
        textAlign: textAlign,
        maxLines: 1
    );
    textPainter.layout();

    final secondaryTextWidth = textPainter.width;

    var textLeft = indicatorPosition - secondaryTextWidth/2;
    if(textLeft <= 0) {
      textLeft = 0.0;
      textAlign = ui.TextAlign.start;
    }
    var textRight = textLeft + secondaryTextWidth;

    if(textRight >= size.width) {
      textRight = size.width;
      textAlign = ui.TextAlign.end;
      textLeft = textRight - secondaryTextWidth;
    }
    final textTop = sliderRect.bottom + secondaryTextMarginTop;
    final textBottom = textTop + textPainter.height;

    final textRect = ui.Rect.fromLTRB(
        textLeft,
        textTop,
        textRight,
        textBottom);

    drawText(canvas, textRect, textPainter);
  }

  /// Draw 2 lines text, to be used to draw primary text layout
  /// Text Alignment is always Center
  void draw2LinesText(
      ui.Canvas canvas,
      ui.Rect boundary,
      TextPainter line1Painter,
      TextPainter line2Painter) {
    ui.Offset primaryLine = new ui.Offset(0.0, boundary.height * 0.05);
    ui.Offset secondaryLine = new ui.Offset(0.0, boundary.height * 0.6);

    // draw line 1
    canvas.save();
    canvas.translate(boundary.left + (boundary.width - line1Painter.width)/2, boundary.top);
    line1Painter.paint(canvas, primaryLine);
    canvas.restore();

    // draw line1
    canvas.save();
    canvas.translate(boundary.left + (boundary.width - line2Painter.width)/2, boundary.top);
    line2Painter.paint(canvas, secondaryLine);
    canvas.restore();
  }

  /// Draw single line text
  /// Text Alignment by default is center
  void drawText(
      ui.Canvas canvas,
      ui.Rect boundary,
      TextPainter painter,
      {TextAlign textAlign = TextAlign.center}
      ) {
    ui.Offset offset = new ui.Offset(0.0, boundary.top + (boundary.height - painter.height)/2);

    canvas.save();
    switch(textAlign) {
      case TextAlign.center:
        canvas.translate(boundary.left + (boundary.width - painter.width)/2, 0.0);
        break;
      case TextAlign.start:
      case TextAlign.left:
      case TextAlign.justify:
        break;
      case TextAlign.end:
      case TextAlign.right:
        canvas.translate(boundary.left + (boundary.width - painter.width), 0.0);
        break;
    }
    painter.paint(canvas, offset);
    canvas.restore();
  }
}