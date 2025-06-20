// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'preferences': instance.preferences,
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      enablePrayerNotifications:
          json['enablePrayerNotifications'] as bool? ?? true,
      enableLocationTracking: json['enableLocationTracking'] as bool? ?? true,
      madhab: json['madhab'] as String? ?? 'Shafi',
      calculationMethod: json['calculationMethod'] as String? ?? 'MWL',
      prayerNotificationMinutes:
          (json['prayerNotificationMinutes'] as num?)?.toInt() ?? 15,
      language: json['language'] as String? ?? 'en',
      themeMode: json['themeMode'] as String? ?? 'system',
      hasDisability: json['hasDisability'] as bool? ?? false,
      isVisuallyImpaired: json['isVisuallyImpaired'] as bool? ?? false,
      enableEyeControl: json['enableEyeControl'] as bool? ?? false,
      enableAIRealtime: json['enableAIRealtime'] as bool? ?? false,
      hasColorBlindness: json['hasColorBlindness'] as bool? ?? false,
      colorBlindnessType: json['colorBlindnessType'] as String? ?? 'none',
      enableHighContrast: json['enableHighContrast'] as bool? ?? false,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      enableScreenReader: json['enableScreenReader'] as bool? ?? false,
      enableVoiceCommands: json['enableVoiceCommands'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'enablePrayerNotifications': instance.enablePrayerNotifications,
      'enableLocationTracking': instance.enableLocationTracking,
      'madhab': instance.madhab,
      'calculationMethod': instance.calculationMethod,
      'prayerNotificationMinutes': instance.prayerNotificationMinutes,
      'language': instance.language,
      'themeMode': instance.themeMode,
      'hasDisability': instance.hasDisability,
      'isVisuallyImpaired': instance.isVisuallyImpaired,
      'enableEyeControl': instance.enableEyeControl,
      'enableAIRealtime': instance.enableAIRealtime,
      'hasColorBlindness': instance.hasColorBlindness,
      'colorBlindnessType': instance.colorBlindnessType,
      'enableHighContrast': instance.enableHighContrast,
      'textScaleFactor': instance.textScaleFactor,
      'enableScreenReader': instance.enableScreenReader,
      'enableVoiceCommands': instance.enableVoiceCommands,
    };
