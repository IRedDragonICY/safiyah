import 'package:flutter/material.dart';

class ColorBlindnessService {
  static final ColorBlindnessService _instance = ColorBlindnessService._internal();
  factory ColorBlindnessService() => _instance;
  ColorBlindnessService._internal();

  String _colorBlindnessType = 'none';
  bool _enableHighContrast = false;

  // Getters
  String get colorBlindnessType => _colorBlindnessType;
  bool get isHighContrastEnabled => _enableHighContrast;

  // Update settings
  void setColorBlindnessType(String type) {
    _colorBlindnessType = type;
  }

  void setHighContrast(bool enabled) {
    _enableHighContrast = enabled;
  }

  // Apply color blindness filter to a color
  Color applyColorFilter(Color originalColor) {
    if (_colorBlindnessType == 'none') {
      return _enableHighContrast ? _applyHighContrast(originalColor) : originalColor;
    }

    Color filteredColor;
    switch (_colorBlindnessType) {
      case 'deuteranopia':
        filteredColor = _applyDeuteranopia(originalColor);
        break;
      case 'protanopia':
        filteredColor = _applyProtanopia(originalColor);
        break;
      case 'tritanopia':
        filteredColor = _applyTritanopia(originalColor);
        break;
      default:
        filteredColor = originalColor;
    }

    return _enableHighContrast ? _applyHighContrast(filteredColor) : filteredColor;
  }

  // High contrast adjustment
  Color _applyHighContrast(Color color) {
    // Increase contrast by making colors more vibrant or more muted
    final hsl = HSLColor.fromColor(color);
    
    // Increase saturation and adjust lightness for better contrast
    final adjustedSaturation = (hsl.saturation * 1.3).clamp(0.0, 1.0);
    final adjustedLightness = hsl.lightness < 0.5 
        ? (hsl.lightness * 0.7).clamp(0.0, 1.0)  // Make dark colors darker
        : (hsl.lightness * 1.2).clamp(0.0, 1.0); // Make light colors lighter
    
    return hsl.withSaturation(adjustedSaturation)
              .withLightness(adjustedLightness)
              .toColor();
  }

  // Deuteranopia (Green color blindness) filter
  Color _applyDeuteranopia(Color color) {
    final r = (color.r * 255.0).round() / 255.0;
    final g = (color.g * 255.0).round() / 255.0;
    final b = (color.b * 255.0).round() / 255.0;

    // Deuteranopia transformation matrix
    final newR = (0.625 * r + 0.375 * g).clamp(0.0, 1.0);
    final newG = (0.7 * r + 0.3 * g).clamp(0.0, 1.0);
    final newB = b;

    return Color.fromARGB(
      (color.a * 255.0).round(),
      (newR * 255).round(),
      (newG * 255).round(),
      (newB * 255).round(),
    );
  }

  // Protanopia (Red color blindness) filter
  Color _applyProtanopia(Color color) {
    final r = (color.r * 255.0).round() / 255.0;
    final g = (color.g * 255.0).round() / 255.0;
    final b = (color.b * 255.0).round() / 255.0;

    // Protanopia transformation matrix
    final newR = (0.567 * r + 0.433 * g).clamp(0.0, 1.0);
    final newG = (0.558 * r + 0.442 * g).clamp(0.0, 1.0);
    final newB = b;

    return Color.fromARGB(
      (color.a * 255.0).round(),
      (newR * 255).round(),
      (newG * 255).round(),
      (newB * 255).round(),
    );
  }

  // Tritanopia (Blue color blindness) filter
  Color _applyTritanopia(Color color) {
    final r = (color.r * 255.0).round() / 255.0;
    final g = (color.g * 255.0).round() / 255.0;
    final b = (color.b * 255.0).round() / 255.0;

    // Tritanopia transformation matrix
    final newR = (0.95 * r + 0.05 * g).clamp(0.0, 1.0);
    final newG = g;
    final newB = (0.433 * g + 0.567 * b).clamp(0.0, 1.0);

    return Color.fromARGB(
      (color.a * 255.0).round(),
      (newR * 255).round(),
      (newG * 255).round(),
      (newB * 255).round(),
    );
  }

  // Apply filter to a complete ColorScheme
  ColorScheme applyColorSchemeFilter(ColorScheme originalScheme) {
    return ColorScheme(
      brightness: originalScheme.brightness,
      primary: applyColorFilter(originalScheme.primary),
      onPrimary: applyColorFilter(originalScheme.onPrimary),
      secondary: applyColorFilter(originalScheme.secondary),
      onSecondary: applyColorFilter(originalScheme.onSecondary),
      error: applyColorFilter(originalScheme.error),
      onError: applyColorFilter(originalScheme.onError),
      surface: applyColorFilter(originalScheme.surface),
      onSurface: applyColorFilter(originalScheme.onSurface),
      // New Material 3 colors
      primaryContainer: applyColorFilter(originalScheme.primaryContainer),
      onPrimaryContainer: applyColorFilter(originalScheme.onPrimaryContainer),
      secondaryContainer: applyColorFilter(originalScheme.secondaryContainer),
      onSecondaryContainer: applyColorFilter(originalScheme.onSecondaryContainer),
      tertiary: applyColorFilter(originalScheme.tertiary),
      onTertiary: applyColorFilter(originalScheme.onTertiary),
      tertiaryContainer: applyColorFilter(originalScheme.tertiaryContainer),
      onTertiaryContainer: applyColorFilter(originalScheme.onTertiaryContainer),
      errorContainer: applyColorFilter(originalScheme.errorContainer),
      onErrorContainer: applyColorFilter(originalScheme.onErrorContainer),
      surfaceVariant: applyColorFilter(originalScheme.surfaceVariant),
      onSurfaceVariant: applyColorFilter(originalScheme.onSurfaceVariant),
      outline: applyColorFilter(originalScheme.outline),
      outlineVariant: applyColorFilter(originalScheme.outlineVariant),
      shadow: applyColorFilter(originalScheme.shadow),
      scrim: applyColorFilter(originalScheme.scrim),
      inverseSurface: applyColorFilter(originalScheme.inverseSurface),
      onInverseSurface: applyColorFilter(originalScheme.onInverseSurface),
      inversePrimary: applyColorFilter(originalScheme.inversePrimary),
      surfaceTint: applyColorFilter(originalScheme.surfaceTint),
    );
  }

  // Get accessibility-friendly color palette for specific conditions
  Map<String, Color> getAccessibilityColors() {
    final baseColors = {
      'success': const Color(0xFF4CAF50),
      'warning': const Color(0xFFFF9800),
      'error': const Color(0xFFE53935),
      'info': const Color(0xFF2196F3),
      'primary': const Color(0xFF00C853),
      'secondary': const Color(0xFFFF6D00),
    };

    return baseColors.map((key, color) => MapEntry(key, applyColorFilter(color)));
  }

  // Check if two colors have sufficient contrast
  bool hasGoodContrast(Color foreground, Color background) {
    final foregroundLuminance = _calculateLuminance(foreground);
    final backgroundLuminance = _calculateLuminance(background);
    
    final contrast = (foregroundLuminance + 0.05) / (backgroundLuminance + 0.05);
    
    // WCAG AA standard requires at least 4.5:1 contrast ratio for normal text
    return contrast >= 4.5 || (1 / contrast) >= 4.5;
  }

  // Calculate relative luminance for contrast checking
  double _calculateLuminance(Color color) {
    final r = _linearizeColorComponent((color.r * 255.0).round() / 255.0);
    final g = _linearizeColorComponent((color.g * 255.0).round() / 255.0);
    final b = _linearizeColorComponent((color.b * 255.0).round() / 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _linearizeColorComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    } else {
      return ((component + 0.055) / 1.055).pow(2.4);
    }
  }
}

extension Pow on double {
  double pow(double exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent.round(); i++) {
      result *= this;
    }
    return result;
  }
} 