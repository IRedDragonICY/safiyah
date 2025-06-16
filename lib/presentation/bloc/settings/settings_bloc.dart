import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth/auth_bloc.dart';
import '../auth/auth_event.dart';
import '../auth/auth_state.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  SettingsBloc({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeTheme>(_onChangeTheme);
  }

  ThemeMode _mapStringToThemeMode(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _mapThemeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      final prefs = authState.user.preferences;
      emit(SettingsLoaded(
        preferences: prefs,
        themeMode: _mapStringToThemeMode(prefs.themeMode),
      ));
    } else {
      emit(const SettingsLoaded(
        preferences: UserPreferences(),
        themeMode: ThemeMode.system,
      ));
    }
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<SettingsState> emit,
  ) async {
    UserPreferences currentPrefs = const UserPreferences();
    if (state is SettingsLoaded) {
      currentPrefs = (state as SettingsLoaded).preferences;
    }

    final newPrefs = currentPrefs.copyWith(
      themeMode: _mapThemeModeToString(event.themeMode),
    );

    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      final updatedUser = authState.user.copyWith(preferences: newPrefs);
      await _authRepository.updateUserProfile(updatedUser);
      _authBloc.add(UpdateUserProfile(user: updatedUser));
    }

    emit(SettingsLoaded(
      preferences: newPrefs,
      themeMode: event.themeMode,
    ));
  }
}