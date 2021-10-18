import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_clock_app/services/utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 64,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: CustomPaint(
              painter: ClockPainter(context),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 0,
          right: 0,
          child: Utility.isDayTime
              ? SvgPicture.asset(
                  'assets/images/svg/sun.svg',
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.03
                          : MediaQuery.of(context).size.height * 0.06,
                  color: Colors.orangeAccent[700],
                )
              : SvgPicture.asset(
                  'assets/images/svg/moon.svg',
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.03
                          : MediaQuery.of(context).size.height * 0.06,
                  color: Colors.yellow[700],
                ),
        )
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final BuildContext context;

  ClockPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    Offset center = Offset(centerX, centerY);
    //Indicators
    //10s
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: 30,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: 60,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: 120,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: 150,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: -30,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: -60,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: -120,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.43,
      length: 10,
      angle: -150,
      paint: Paint()
        ..color = Colors.blueGrey[100]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    //quarters
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.4,
      length: 20,
      angle: 0,
      paint: Paint()
        ..color = Colors.blueGrey[200]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.4,
      length: 20,
      angle: 180,
      paint: Paint()
        ..color = Colors.blueGrey[200]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: size.width * 0.4,
      length: 20,
      angle: -90,
      paint: Paint()
        ..color = Colors.blueGrey[200]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    //hands
    //hour
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: 0,
      length: size.width * 0.27,
      angle: -Utility.hour / 12 * 360 + 90,
      paint: Paint()
        ..color = Colors.grey[300]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );
    //minute
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: 0,
      length: size.width * 0.35,
      angle: -Utility.minute / 60 * 360 + 90,
      paint: Paint()
        ..color = Colors.blueGrey[400]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    //second
    drawIndicator(
      canvas: canvas,
      center: center,
      distant: 0,
      length: size.width * 0.4,
      angle: -Utility.second / 60 * 360 + 90,
      paint: Paint()
        ..color = Colors.red[300]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    //pivot
    canvas.drawCircle(
      center,
      size.width * 0.05,
      Paint()..color = Utility.themeColor,
    );
    canvas.drawCircle(
      center,
      size.width * 0.04,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      size.width * 0.01,
      Paint()..color = Utility.themeColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawIndicator(
      {Canvas canvas,
      Offset center,
      double distant,
      double length,
      double angle,
      Paint paint}) {
    angle *= -pi / 180;
    double factorX = cos(angle);
    double factorY = sin(angle);

    Offset start =
        Offset(center.dx + distant * factorX, center.dy + distant * factorY);
    Offset end =
        Offset(start.dx + length * factorX, start.dy + length * factorY);
    return canvas.drawLine(
      start,
      end,
      paint,
    );
  }
}
