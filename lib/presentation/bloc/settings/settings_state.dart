import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoaded extends SettingsState {
  final UserPreferences preferences;
  final ThemeMode themeMode;
  final String paletteName; // 'device', 'green', 'orange', 'blue'

  const SettingsLoaded({
    required this.preferences,
    required this.themeMode,
    this.paletteName = 'device',
  });

  SettingsLoaded copyWith({
    UserPreferences? preferences,
    ThemeMode? themeMode,
    String? paletteName,
  }) {
    return SettingsLoaded(
      preferences: preferences ?? this.preferences,
      themeMode: themeMode ?? this.themeMode,
      paletteName: paletteName ?? this.paletteName,
    );
  }

  @override
  List<Object?> get props => [preferences, themeMode, paletteName];
}