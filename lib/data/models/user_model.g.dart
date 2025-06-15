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
      darkMode: json['darkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'enablePrayerNotifications': instance.enablePrayerNotifications,
      'enableLocationTracking': instance.enableLocationTracking,
      'madhab': instance.madhab,
      'calculationMethod': instance.calculationMethod,
      'prayerNotificationMinutes': instance.prayerNotificationMinutes,
      'darkMode': instance.darkMode,
      'language': instance.language,
    };
