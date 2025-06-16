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

  const SettingsLoaded({
    required this.preferences,
    required this.themeMode,
  });

  @override
  List<Object?> get props => [preferences, themeMode];
}