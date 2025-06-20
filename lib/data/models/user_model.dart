import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences preferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        profileImageUrl,
        createdAt,
        updatedAt,
        preferences,
      ];
}

@JsonSerializable()
class UserPreferences extends Equatable {
  final bool enablePrayerNotifications;
  final bool enableLocationTracking;
  final String madhab; // Hanafi, Shafi, Maliki, Hanbali
  final String calculationMethod; // MWL, ISNA, Egypt, etc.
  final int prayerNotificationMinutes;
  final String language;
  final String themeMode; // 'system', 'light', 'dark'
  
  // Accessibility features
  final bool hasDisability;
  final bool isVisuallyImpaired;
  final bool enableEyeControl;
  final bool enableAIRealtime;
  final bool hasColorBlindness;
  final String colorBlindnessType; // 'none', 'deuteranopia', 'protanopia', 'tritanopia'
  final bool enableHighContrast;
  final double textScaleFactor;
  final bool enableScreenReader;
  final bool enableVoiceCommands;

  const UserPreferences({
    this.enablePrayerNotifications = true,
    this.enableLocationTracking = true,
    this.madhab = 'Shafi',
    this.calculationMethod = 'MWL',
    this.prayerNotificationMinutes = 15,
    this.language = 'en',
    this.themeMode = 'system',
    // Accessibility defaults
    this.hasDisability = false,
    this.isVisuallyImpaired = false,
    this.enableEyeControl = false,
    this.enableAIRealtime = false,
    this.hasColorBlindness = false,
    this.colorBlindnessType = 'none',
    this.enableHighContrast = false,
    this.textScaleFactor = 1.0,
    this.enableScreenReader = false,
    this.enableVoiceCommands = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    bool? enablePrayerNotifications,
    bool? enableLocationTracking,
    String? madhab,
    String? calculationMethod,
    int? prayerNotificationMinutes,
    String? language,
    String? themeMode,
    bool? hasDisability,
    bool? isVisuallyImpaired,
    bool? enableEyeControl,
    bool? enableAIRealtime,
    bool? hasColorBlindness,
    String? colorBlindnessType,
    bool? enableHighContrast,
    double? textScaleFactor,
    bool? enableScreenReader,
    bool? enableVoiceCommands,
  }) {
    return UserPreferences(
      enablePrayerNotifications:
          enablePrayerNotifications ?? this.enablePrayerNotifications,
      enableLocationTracking:
          enableLocationTracking ?? this.enableLocationTracking,
      madhab: madhab ?? this.madhab,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      prayerNotificationMinutes:
          prayerNotificationMinutes ?? this.prayerNotificationMinutes,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      hasDisability: hasDisability ?? this.hasDisability,
      isVisuallyImpaired: isVisuallyImpaired ?? this.isVisuallyImpaired,
      enableEyeControl: enableEyeControl ?? this.enableEyeControl,
      enableAIRealtime: enableAIRealtime ?? this.enableAIRealtime,
      hasColorBlindness: hasColorBlindness ?? this.hasColorBlindness,
      colorBlindnessType: colorBlindnessType ?? this.colorBlindnessType,
      enableHighContrast: enableHighContrast ?? this.enableHighContrast,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      enableScreenReader: enableScreenReader ?? this.enableScreenReader,
      enableVoiceCommands: enableVoiceCommands ?? this.enableVoiceCommands,
    );
  }

  @override
  List<Object?> get props => [
        enablePrayerNotifications,
        enableLocationTracking,
        madhab,
        calculationMethod,
        prayerNotificationMinutes,
        language,
        themeMode,
        hasDisability,
        isVisuallyImpaired,
        enableEyeControl,
        enableAIRealtime,
        hasColorBlindness,
        colorBlindnessType,
        enableHighContrast,
        textScaleFactor,
        enableScreenReader,
        enableVoiceCommands,
      ];
}
