import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math' as math;

class CameraStabilizer {
  late final StreamSubscription<AccelerometerEvent> _accelSubscription;
  double _pitch = 0.0;
  double _roll = 0.0;
  Function(double, double)? onOrientationChanged;
  bool _isEnabled = false;
  Timer? _vibrationTimer;
  DateTime? _lastVibrationTime;
  
  CameraStabilizer({this.onOrientationChanged});

  void init() {
    _accelSubscription = accelerometerEventStream().listen(_updateOrientation);
  }

  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = false;
    Vibration.cancel();
    _vibrationTimer?.cancel();
  }

  void _updateOrientation(AccelerometerEvent event) {
    // Calculate pitch (forward/backward tilt)
    _pitch = math.atan2(-event.y, event.z) * (180 / math.pi);
    
    // Calculate roll (left/right tilt)
    _roll = math.atan2(event.x, event.z) * (180 / math.pi);
    
    onOrientationChanged?.call(_pitch, _roll);
    
    if (_isEnabled) {
      _vibrateBasedOnOrientation();
    }
  }

  Future<void> _vibrateBasedOnOrientation() async {
    // Don't vibrate too frequently
    final now = DateTime.now();
    if (_lastVibrationTime != null && 
        now.difference(_lastVibrationTime!).inMilliseconds < 200) {
      return;
    }
    
    // Calculate how far we are from the ideal position (device pointing forward)
    // Ideal pitch is around -90 degrees (device vertical)
    // Ideal roll is around 0 degrees (device level)
    final pitchOffset = (_pitch + 90).abs();
    final rollOffset = _roll.abs();
    
    // Calculate total offset
    final totalOffset = math.sqrt(pitchOffset * pitchOffset + rollOffset * rollOffset);
    
    // If camera is reasonably centered, don't vibrate
    if (totalOffset < 10.0) {
      Vibration.cancel();
      return;
    }
    
    // Vibrate with intensity based on how far off we are
    final intensity = (totalOffset / 90 * 255).clamp(50, 255).toInt();
    final duration = (totalOffset / 90 * 300).clamp(50, 300).toInt();
    
    // Determine vibration pattern based on direction
    List<int> pattern = [];
    
    if (pitchOffset > rollOffset) {
      // Need to adjust pitch more
      if (_pitch > -90) {
        // Tilt down - double vibration
        pattern = [0, duration, 50, duration];
      } else {
        // Tilt up - single vibration
        pattern = [0, duration];
      }
    } else {
      // Need to adjust roll more
      if (_roll > 0) {
        // Tilt left - triple short vibration
        pattern = [0, 50, 50, 50, 50, 50];
      } else {
        // Tilt right - long vibration
        pattern = [0, duration * 2];
      }
    }
    
    _lastVibrationTime = now;
    
    if (await Vibration.hasVibrator() ?? false) {
      if (await Vibration.hasAmplitudeControl() ?? false) {
        Vibration.vibrate(pattern: pattern, amplitude: intensity);
      } else {
        Vibration.vibrate(pattern: pattern);
      }
    }
  }

  double get pitch => _pitch;
  double get roll => _roll;
  
  bool get isWithinRange {
    final pitchOffset = (_pitch + 90).abs();
    final rollOffset = _roll.abs();
    final totalOffset = math.sqrt(pitchOffset * pitchOffset + rollOffset * rollOffset);
    return totalOffset < 10.0;
  }

  void dispose() {
    _accelSubscription.cancel();
    _vibrationTimer?.cancel();
    Vibration.cancel();
  }
} 
