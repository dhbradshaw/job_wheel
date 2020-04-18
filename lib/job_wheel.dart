import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:ui' as ui;

class JobWheel extends StatelessWidget {
  final List<String> outerChoices;
  final List<String> innerChoices;
  final double number;
  JobWheel({
    Key key,
    this.number,
    this.outerChoices,
    this.innerChoices,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SubWheel(
        choices: this.outerChoices,
        backgroundColor: Colors.green,
        edgeInsets: EdgeInsets.all(0),
        number: 0,
      ),
      SubWheel(
        choices: this.innerChoices,
        backgroundColor: Colors.pink,
        edgeInsets: EdgeInsets.all(100),
        number: number,
      ),
    ]);
  }
}

class SubWheel extends StatelessWidget {
  final EdgeInsets edgeInsets;
  final List<String> choices;
  final MaterialColor backgroundColor;
  final double number;

  SubWheel({
    Key key,
    this.backgroundColor,
    this.choices,
    this.edgeInsets, // TODO use scaling instead?
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: edgeInsets,
      width: 50000,
      child: Center(
        child: AspectRatio(
          child: CustomPaint(painter: Star(
            number: number,
            choices: choices,
          )),
          aspectRatio: 1 / 1,
        ),
      ),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          new BoxShadow(
            offset: new Offset(0.0, 5.0),
            blurRadius: 5.0,
          )
        ],
      ),
    );
  }
}

class Star extends CustomPainter {
  final List<String> choices;
  double number;
  Star({this.choices, this.number}) : super();
  @override
  void paint(Canvas canvas, Size size) {
    // basic geometry
    var radius = min(size.width / 2, size.height / 2);
    var angle = 2 * pi / choices.length;
    var offset_angle = 2 * pi * number / choices.length;

    // linePaint
    var linePaint = Paint();
    linePaint.color = Color(0xFF000000);
    linePaint.strokeWidth = size.width / 200;
    linePaint.strokeCap = StrokeCap.round;

    // Draw lines
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(offset_angle);
    for (var _ in Iterable.generate(choices.length)) {
      canvas.drawLine(Offset(0, 0), Offset(0, -radius), linePaint);
      canvas.rotate(angle);
    }
    canvas.restore();

    // Draw text
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    final writeRadius = 11 * radius / 12;
    final writeWidth = angle * writeRadius;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(offset_angle);
    canvas.rotate(angle / 2);
    final constraints = ui.ParagraphConstraints(width: 1000);

    ui.Paragraph prepareParagraph(String text, double fontSize) {
      ui.TextStyle textStyle = ui.TextStyle(
        color: Colors.black,
        fontFamily: "Roboto",
        fontSize: fontSize,
      );
      ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(text);
      ui.Paragraph paragraph = paragraphBuilder.build();
      paragraph.layout(constraints);
      return paragraph;
    }

    for (var i in Iterable.generate(choices.length)) {
      double fontSize = 40;
      final text = choices[i];
      ui.Paragraph paragraph = prepareParagraph(text, fontSize);
      while (paragraph.maxIntrinsicWidth > writeWidth - fontSize) {
        fontSize -= 1;
        paragraph = prepareParagraph(text, fontSize);
      }

      canvas.drawParagraph(
          paragraph, Offset(-paragraph.maxIntrinsicWidth / 2, -writeRadius));
      canvas.rotate(angle);
    }
    canvas.restore();

    void paintLines() {}
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Star oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Star oldDelegate) => false;
}
