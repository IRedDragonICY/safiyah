import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

import '../../../core/constants/colors.dart';

class QiblaCompass extends StatefulWidget {
  final double qiblaDirection;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? _compassHeading;

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  void _initCompass() {
    if (kIsWeb) return;
    FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _compassHeading = event.heading;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebFallback();
    }

    if (_compassHeading == null) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Calibrating compass...'),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: ((_compassHeading ?? 0) * (math.pi / 180) * -1),
            child: CustomPaint(
              size: const Size(300, 300),
              painter: CompassPainter(),
            ),
          ),
          Transform.rotate(
            angle: ((widget.qiblaDirection - (_compassHeading ?? 0)) * (math.pi / 180)),
            child: CustomPaint(
              size: const Size(300, 300),
              painter: QiblaNeedlePainter(),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Transform.rotate(
            angle: ((widget.qiblaDirection - (_compassHeading ?? 0)) * (math.pi / 180)),
            child: Transform.translate(
              offset: const Offset(0, -110),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.qiblaDirection,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebFallback() {
    return Container(
      height: 300,
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Live Compass Not Available on Web',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Point your device North to align with the Qibla direction shown.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    final angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      final angle = angles[i] * math.pi / 180;
      final x = center.dx + (radius - 15) * math.sin(angle);
      final y = center.dy - (radius - 15) * math.cos(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: i == 0 ? Colors.red : Colors.grey[600],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    paint.color = Colors.grey.withOpacity(0.5);
    paint.strokeWidth = 1;

    for (int i = 0; i < 360; i += 10) {
      final angle = i * math.pi / 180;
      final startRadius = i % 30 == 0 ? radius - 15 : radius - 8;
      final endRadius = radius;

      final startX = center.dx + startRadius * math.sin(angle);
      final startY = center.dy - startRadius * math.cos(angle);
      final endX = center.dx + endRadius * math.sin(angle);
      final endY = center.dy - endRadius * math.cos(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QiblaNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.qiblaDirection
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - 100);
    path.lineTo(center.dx - 8, center.dy + 20);
    path.lineTo(center.dx + 8, center.dy + 20);
    path.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    paint.color = AppColors.qiblaDirection.withOpacity(0.8);
    canvas.drawCircle(Offset(center.dx, center.dy + 15), 4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}