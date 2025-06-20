import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ChangeTheme extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeTheme({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

class ChangePalette extends SettingsEvent {
  final String paletteName; // 'device', 'green', 'orange', 'blue'

  const ChangePalette({required this.paletteName});

  @override
  List<Object?> get props => [paletteName];
}

// Accessibility Events
class ToggleAccessibilityFeatures extends SettingsEvent {
  final bool enabled;

  const ToggleAccessibilityFeatures({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleVisualImpairment extends SettingsEvent {
  final bool enabled;

  const ToggleVisualImpairment({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleEyeControl extends SettingsEvent {
  final bool enabled;

  const ToggleEyeControl({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleScreenReader extends SettingsEvent {
  final bool enabled;

  const ToggleScreenReader({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleVoiceCommands extends SettingsEvent {
  final bool enabled;

  const ToggleVoiceCommands({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleColorBlindness extends SettingsEvent {
  final bool enabled;

  const ToggleColorBlindness({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ChangeColorBlindnessType extends SettingsEvent {
  final String type; // 'none', 'deuteranopia', 'protanopia', 'tritanopia'

  const ChangeColorBlindnessType({required this.type});

  @override
  List<Object?> get props => [type];
}

class ToggleHighContrast extends SettingsEvent {
  final bool enabled;

  const ToggleHighContrast({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ChangeTextScale extends SettingsEvent {
  final double scaleFactor;

  const ChangeTextScale({required this.scaleFactor});

  @override
  List<Object?> get props => [scaleFactor];
}
