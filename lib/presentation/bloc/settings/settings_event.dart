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
