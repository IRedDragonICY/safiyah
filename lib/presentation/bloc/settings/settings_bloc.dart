import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/ai_accessibility_service.dart';
import '../../../core/services/color_blindness_service.dart';
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
  final AIAccessibilityService _aiService = AIAccessibilityService();
  final ColorBlindnessService _colorBlindnessService = ColorBlindnessService();

  SettingsBloc({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ChangeTheme>(_onChangeTheme);
    on<ChangePalette>(_onChangePalette);
    
    // Accessibility event handlers
    on<ToggleAccessibilityFeatures>(_onToggleAccessibilityFeatures);
    on<ToggleVisualImpairment>(_onToggleVisualImpairment);
    on<ToggleEyeControl>(_onToggleEyeControl);
    on<ToggleScreenReader>(_onToggleScreenReader);
    on<ToggleVoiceCommands>(_onToggleVoiceCommands);
    on<ToggleColorBlindness>(_onToggleColorBlindness);
    on<ChangeColorBlindnessType>(_onChangeColorBlindnessType);
    on<ToggleHighContrast>(_onToggleHighContrast);
    on<ChangeTextScale>(_onChangeTextScale);
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

  Future<void> _updateUserPreferences(UserPreferences newPrefs) async {
    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      final updatedUser = authState.user.copyWith(preferences: newPrefs);
      await _authRepository.updateUserProfile(updatedUser);
      _authBloc.add(UpdateUserProfile(user: updatedUser));
    }
  }

  void _updateColorBlindnessService(UserPreferences prefs) {
    // Update color blindness service
    _colorBlindnessService.setColorBlindnessType(prefs.colorBlindnessType);
    _colorBlindnessService.setHighContrast(prefs.enableHighContrast);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final authState = _authBloc.state;
    if (authState is AuthAuthenticated) {
      final prefs = authState.user.preferences;
      
      // Initialize AI services based on preferences
      if (prefs.enableEyeControl) _aiService.enableEyeControl();
      if (prefs.enableAIRealtime) _aiService.enableRealtimeAssistance();
      if (prefs.enableScreenReader) _aiService.enableScreenReader();
      if (prefs.enableVoiceCommands) _aiService.enableVoiceCommands();
      
      // Initialize color blindness service
      _updateColorBlindnessService(prefs);
      
      emit(SettingsLoaded(
        preferences: prefs,
        themeMode: _mapStringToThemeMode(prefs.themeMode),
        paletteName: 'green',
      ));
    } else {
      emit(const SettingsLoaded(
        preferences: UserPreferences(),
        themeMode: ThemeMode.system,
        paletteName: 'green',
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

    await _updateUserPreferences(newPrefs);

    String currentPalette = 'green';
    if (state is SettingsLoaded) {
      currentPalette = (state as SettingsLoaded).paletteName;
    }

    emit(SettingsLoaded(
      preferences: newPrefs,
      themeMode: event.themeMode,
      paletteName: currentPalette,
    ));
  }

  Future<void> _onChangePalette(
    ChangePalette event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final updated = (state as SettingsLoaded).copyWith(paletteName: event.paletteName);
      emit(updated);
    }
  }

  // Accessibility Event Handlers
  Future<void> _onToggleAccessibilityFeatures(
    ToggleAccessibilityFeatures event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(
        hasDisability: event.enabled,
        // Reset all accessibility features if disabled
        isVisuallyImpaired: event.enabled ? currentState.preferences.isVisuallyImpaired : false,
        enableEyeControl: event.enabled ? currentState.preferences.enableEyeControl : false,
        enableScreenReader: event.enabled ? currentState.preferences.enableScreenReader : false,
        enableVoiceCommands: event.enabled ? currentState.preferences.enableVoiceCommands : false,
        hasColorBlindness: event.enabled ? currentState.preferences.hasColorBlindness : false,
        enableHighContrast: event.enabled ? currentState.preferences.enableHighContrast : false,
      );

      if (!event.enabled) {
        // Disable all AI services
        _aiService.disableEyeControl();
        _aiService.disableRealtimeAssistance();
        _aiService.disableScreenReader();
        _aiService.disableVoiceCommands();
        
        // Reset color blindness service
        _colorBlindnessService.setColorBlindnessType('none');
        _colorBlindnessService.setHighContrast(false);
      }

      _updateColorBlindnessService(newPrefs);
      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleVisualImpairment(
    ToggleVisualImpairment event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(
        isVisuallyImpaired: event.enabled,
        // Reset visual impairment features if disabled
        enableEyeControl: event.enabled ? currentState.preferences.enableEyeControl : false,
        enableScreenReader: event.enabled ? currentState.preferences.enableScreenReader : false,
        enableVoiceCommands: event.enabled ? currentState.preferences.enableVoiceCommands : false,
      );

      if (!event.enabled) {
        _aiService.disableEyeControl();
        _aiService.disableScreenReader();
        _aiService.disableVoiceCommands();
      }

      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleEyeControl(
    ToggleEyeControl event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(enableEyeControl: event.enabled);

      if (event.enabled) {
        _aiService.enableEyeControl();
      } else {
        _aiService.disableEyeControl();
      }

      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleScreenReader(
    ToggleScreenReader event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(enableScreenReader: event.enabled);

      if (event.enabled) {
        _aiService.enableScreenReader();
      } else {
        _aiService.disableScreenReader();
      }

      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleVoiceCommands(
    ToggleVoiceCommands event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(enableVoiceCommands: event.enabled);

      if (event.enabled) {
        _aiService.enableVoiceCommands();
      } else {
        _aiService.disableVoiceCommands();
      }

      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleColorBlindness(
    ToggleColorBlindness event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(
        hasColorBlindness: event.enabled,
        colorBlindnessType: event.enabled ? currentState.preferences.colorBlindnessType : 'none',
        enableHighContrast: event.enabled ? currentState.preferences.enableHighContrast : false,
      );

      _updateColorBlindnessService(newPrefs);
      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onChangeColorBlindnessType(
    ChangeColorBlindnessType event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(colorBlindnessType: event.type);

      _updateColorBlindnessService(newPrefs);
      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onToggleHighContrast(
    ToggleHighContrast event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(enableHighContrast: event.enabled);

      _updateColorBlindnessService(newPrefs);
      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }

  Future<void> _onChangeTextScale(
    ChangeTextScale event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newPrefs = currentState.preferences.copyWith(textScaleFactor: event.scaleFactor);

      await _updateUserPreferences(newPrefs);
      emit(currentState.copyWith(preferences: newPrefs));
    }
  }
}
