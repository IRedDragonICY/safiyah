import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';

class PathGuideDetector {
  Function(PathGuideInfo)? onPathDetected;
  Timer? _detectionTimer;
  bool _isProcessing = false;
  
  PathGuideDetector({this.onPathDetected});
  
  void startDetection() {
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isProcessing) {
        _processFrame();
      }
    });
  }
  
  void stopDetection() {
    _detectionTimer?.cancel();
  }
  
  Future<void> processImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;
    
    try {
      // Simple edge detection for path/line detection
      final pathInfo = await _detectPathLines(image);
      onPathDetected?.call(pathInfo);
    } finally {
      _isProcessing = false;
    }
  }
  
  Future<PathGuideInfo> _detectPathLines(CameraImage image) async {
    // Simulate path detection - in real implementation would use 
    // computer vision algorithms like Hough transform for line detection
    
    // Mock detection results
    final lines = <PathLine>[];
    final obstacles = <Obstacle>[];
    
    // Detect main path lines (e.g., sidewalk edges, road markings)
    lines.add(PathLine(
      start: const Offset(100, 300),
      end: const Offset(150, 500),
      type: LineType.sidewalkEdge,
      confidence: 0.85,
    ));
    
    lines.add(PathLine(
      start: const Offset(250, 300),
      end: const Offset(200, 500),
      type: LineType.sidewalkEdge,
      confidence: 0.82,
    ));
    
    // Detect crosswalk if present
    if (DateTime.now().second % 10 < 3) {
      lines.add(PathLine(
        start: const Offset(50, 400),
        end: const Offset(350, 400),
        type: LineType.crosswalk,
        confidence: 0.78,
      ));
    }
    
    // Detect obstacles
    if (DateTime.now().second % 7 < 2) {
      obstacles.add(Obstacle(
        position: const Offset(180, 350),
        size: const Size(50, 50),
        type: ObstacleType.unknown,
        distance: 2.5,
      ));
    }
    
    // Calculate suggested path
    final suggestedDirection = _calculateSuggestedDirection(lines, obstacles);
    
    return PathGuideInfo(
      lines: lines,
      obstacles: obstacles,
      suggestedDirection: suggestedDirection,
      confidence: 0.8,
      timestamp: DateTime.now(),
    );
  }
  
  double _calculateSuggestedDirection(List<PathLine> lines, List<Obstacle> obstacles) {
    // Simple algorithm to suggest direction based on detected lines
    if (lines.isEmpty) return 0.0;
    
    // Find the center of the path
    double leftEdge = double.infinity;
    double rightEdge = double.negativeInfinity;
    
    for (final line in lines) {
      if (line.type == LineType.sidewalkEdge) {
        final avgX = (line.start.dx + line.end.dx) / 2;
        leftEdge = avgX < leftEdge ? avgX : leftEdge;
        rightEdge = avgX > rightEdge ? avgX : rightEdge;
      }
    }
    
    if (leftEdge != double.infinity && rightEdge != double.negativeInfinity) {
      final pathCenter = (leftEdge + rightEdge) / 2;
      final screenCenter = 200.0; // Assuming screen width of 400
      
      // Return angle in degrees (-30 to +30)
      return ((pathCenter - screenCenter) / screenCenter * 30).clamp(-30.0, 30.0);
    }
    
    return 0.0;
  }
  
  void _processFrame() {
    // This would be called periodically to process camera frames
    // In real implementation, this would get the current camera frame
  }
  
  void dispose() {
    _detectionTimer?.cancel();
  }
}

class PathGuideInfo {
  final List<PathLine> lines;
  final List<Obstacle> obstacles;
  final double suggestedDirection; // -30 to +30 degrees
  final double confidence;
  final DateTime timestamp;
  
  const PathGuideInfo({
    required this.lines,
    required this.obstacles,
    required this.suggestedDirection,
    required this.confidence,
    required this.timestamp,
  });
  
  bool get hasPath => lines.isNotEmpty;
  bool get hasCrosswalk => lines.any((line) => line.type == LineType.crosswalk);
  bool get hasObstacles => obstacles.isNotEmpty;
  
  String get directionText {
    if (suggestedDirection.abs() < 5) {
      return 'Straight ahead';
    } else if (suggestedDirection < -5) {
      return 'Turn left ${suggestedDirection.abs().toStringAsFixed(0)}°';
    } else {
      return 'Turn right ${suggestedDirection.toStringAsFixed(0)}°';
    }
  }
}

class PathLine {
  final Offset start;
  final Offset end;
  final LineType type;
  final double confidence;
  
  const PathLine({
    required this.start,
    required this.end,
    required this.type,
    required this.confidence,
  });
}

enum LineType {
  sidewalkEdge,
  centerLine,
  crosswalk,
  curb,
  unknown,
}

class Obstacle {
  final Offset position;
  final Size size;
  final ObstacleType type;
  final double distance; // in meters
  
  const Obstacle({
    required this.position,
    required this.size,
    required this.type,
    required this.distance,
  });
}

enum ObstacleType {
  person,
  vehicle,
  pole,
  unknown,
}

// Custom painter for visualizing path guides
class PathGuidePainter extends CustomPainter {
  final PathGuideInfo? pathInfo;
  final bool showGuides;
  
  PathGuidePainter({this.pathInfo, this.showGuides = true});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (!showGuides || pathInfo == null) return;
    
    // Draw detected lines
    for (final line in pathInfo!.lines) {
      final paint = Paint()
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;
        
      switch (line.type) {
        case LineType.sidewalkEdge:
          paint.color = Colors.green.withValues(alpha: 0.8);
          break;
        case LineType.crosswalk:
          paint.color = Colors.yellow.withValues(alpha: 0.8);
          paint.strokeWidth = 5.0;
          break;
        case LineType.centerLine:
          paint.color = Colors.blue.withValues(alpha: 0.8);
          break;
        default:
          paint.color = Colors.white.withValues(alpha: 0.6);
      }
      
      canvas.drawLine(
        Offset(line.start.dx * size.width / 400, line.start.dy * size.height / 600),
        Offset(line.end.dx * size.width / 400, line.end.dy * size.height / 600),
        paint,
      );
    }
    
    // Draw obstacles
    for (final obstacle in pathInfo!.obstacles) {
      final paint = Paint()
        ..color = Colors.red.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
        
      final rect = Rect.fromCenter(
        center: Offset(
          obstacle.position.dx * size.width / 400,
          obstacle.position.dy * size.height / 600,
        ),
        width: obstacle.size.width * size.width / 400,
        height: obstacle.size.height * size.height / 600,
      );
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        paint,
      );
      
      // Draw distance text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${obstacle.distance.toStringAsFixed(1)}m',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        rect.center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
    
    // Draw suggested direction arrow
    if (pathInfo!.suggestedDirection.abs() > 5) {
      final arrowPaint = Paint()
        ..color = Colors.yellow
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
        
      final centerX = size.width / 2;
      final bottomY = size.height - 100;
      
      final path = Path();
      path.moveTo(centerX, bottomY);
      
      final endX = centerX + (pathInfo!.suggestedDirection / 30 * 100);
      path.lineTo(endX, bottomY - 50);
      
      // Arrowhead
      path.moveTo(endX, bottomY - 50);
      path.lineTo(endX - 10, bottomY - 40);
      path.moveTo(endX, bottomY - 50);
      path.lineTo(endX + 10, bottomY - 40);
      
      canvas.drawPath(path, arrowPaint);
    }
  }
  
  @override
  bool shouldRepaint(PathGuidePainter oldDelegate) {
    return pathInfo != oldDelegate.pathInfo || showGuides != oldDelegate.showGuides;
  }
} 