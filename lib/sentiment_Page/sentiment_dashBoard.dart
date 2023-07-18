import 'dart:math';

import 'package:crypto_project/extension/gobal.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class CarDashboard extends StatelessWidget {
  final int value;

  const CarDashboard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth / 1.3,
          height: screenHeight / 3,
          child: CustomPaint(
            painter: DashboardPainter(value: value),
          ),
        ),
      ),
    );
  }
}

class DashboardPainter extends CustomPainter {
  final int value;

  DashboardPainter({required this.value});

  Color fetchValueColor(int value) {
    if (value >= 60) {
      return Colors.lightGreen;
    } else if (value <= 40) {
      return Colors.orangeAccent;
    } else {
      return Colors.white;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height;
    final radius = size.width / 2;

    final dashboardPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color.fromARGB(255, 165, 139, 139), Colors.blueGrey],
        stops: [0.5, 1.0],
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      pi,
      pi,
      true,
      dashboardPaint,
    );

    // final indicatorPaint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.fill;

    // const indicatorWidth = 10.0;
    // const indicatorHeight = 70.0;
    // final indicatorX = centerX - indicatorWidth / 2;
    // final indicatorY = centerY - radius + 80;

    // canvas.drawRect(
    //   Rect.fromLTWH(indicatorX, indicatorY, indicatorWidth, indicatorHeight),
    //   indicatorPaint,
    // );

    final scalePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const scaleLength = 10.0;
    const scaleMargin = 5.0;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (double angle = 0; angle <= pi; angle += pi / 10) {
      final startX = centerX + cos(angle) * (radius - scaleMargin);
      final startY = centerY + sin(angle) * (radius - scaleMargin);
      final endX = centerX + cos(angle) * (radius - scaleMargin - scaleLength);
      final endY = centerY + sin(angle) * (radius - scaleMargin - scaleLength);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), scalePaint);

      // 绘制刻度数值
      final scaleValue = 0 + ((angle / pi) * 100).toInt(); // 从 100 到 0 的刻度值
      final text = '$scaleValue';
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
            color: fetchValueColor(scaleValue),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      final textX =
          centerX + cos(angle + pi) * (radius - scaleMargin - scaleLength - 15);
      final textY =
          centerY + sin(angle + pi) * (radius - scaleMargin - scaleLength - 15);
      textPainter.paint(canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height));
    }

    // 绘制指针
    final pointerPaint = Paint()
      ..color = const Color.fromARGB(255, 242, 82, 71)
      ..strokeWidth = 8.0;

    final resultvalue = value - 50;
    final pointerLength = radius - scaleMargin - 30;
    final pointerX =
        centerX + cos(resultvalue * pi / 100 - pi / 2) * pointerLength;
    final pointerY =
        centerY + sin(resultvalue * pi / 100 - pi / 2) * pointerLength;

    canvas.drawLine(
        Offset(centerX, centerY), Offset(pointerX, pointerY), pointerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
