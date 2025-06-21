class DhikrModel {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String meaning;
  final DhikrCategory category;
  final int recommendedCount;
  final String source; // Quran/Hadith reference
  final String benefits;
  final List<String> occasions; // morning, evening, after prayer, etc.
  final String audioUrl;
  final bool isFavorite;

  DhikrModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.meaning,
    required this.category,
    required this.recommendedCount,
    required this.source,
    required this.benefits,
    required this.occasions,
    required this.audioUrl,
    this.isFavorite = false,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      arabicText: json['arabicText'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      meaning: json['meaning'] ?? '',
      category: DhikrCategory.values.firstWhere(
        (cat) => cat.toString().split('.').last == json['category'],
        orElse: () => DhikrCategory.general,
      ),
      recommendedCount: json['recommendedCount'] ?? 1,
      source: json['source'] ?? '',
      benefits: json['benefits'] ?? '',
      occasions: List<String>.from(json['occasions'] ?? []),
      audioUrl: json['audioUrl'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'transliteration': transliteration,
      'translation': translation,
      'meaning': meaning,
      'category': category.toString().split('.').last,
      'recommendedCount': recommendedCount,
      'source': source,
      'benefits': benefits,
      'occasions': occasions,
      'audioUrl': audioUrl,
      'isFavorite': isFavorite,
    };
  }

  DhikrModel copyWith({
    String? id,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? meaning,
    DhikrCategory? category,
    int? recommendedCount,
    String? source,
    String? benefits,
    List<String>? occasions,
    String? audioUrl,
    bool? isFavorite,
  }) {
    return DhikrModel(
      id: id ?? this.id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      meaning: meaning ?? this.meaning,
      category: category ?? this.category,
      recommendedCount: recommendedCount ?? this.recommendedCount,
      source: source ?? this.source,
      benefits: benefits ?? this.benefits,
      occasions: occasions ?? this.occasions,
      audioUrl: audioUrl ?? this.audioUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

enum DhikrCategory {
  morning,
  evening,
  afterPrayer,
  beforeSleep,
  protection,
  forgiveness,
  gratitude,
  general,
}

enum CounterDirection {
  increment,
  decrement,
}

class DhikrProgress {
  final String dhikrId;
  final int currentCount;
  final int targetCount;
  final DateTime lastUpdated;
  final bool isCompleted;

  DhikrProgress({
    required this.dhikrId,
    required this.currentCount,
    required this.targetCount,
    required this.lastUpdated,
    required this.isCompleted,
  });

  factory DhikrProgress.fromJson(Map<String, dynamic> json) {
    return DhikrProgress(
      dhikrId: json['dhikrId'] ?? '',
      currentCount: json['currentCount'] ?? 0,
      targetCount: json['targetCount'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dhikrId': dhikrId,
      'currentCount': currentCount,
      'targetCount': targetCount,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  DhikrProgress copyWith({
    String? dhikrId,
    int? currentCount,
    int? targetCount,
    DateTime? lastUpdated,
    bool? isCompleted,
  }) {
    return DhikrProgress(
      dhikrId: dhikrId ?? this.dhikrId,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progressPercentage {
    if (targetCount == 0) return 0.0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }
}

class DhikrSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final List<DhikrProgress> completedDhikr;
  final int totalCount;
  final Duration duration;

  DhikrSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.completedDhikr,
    required this.totalCount,
    required this.duration,
  });

  factory DhikrSession.fromJson(Map<String, dynamic> json) {
    return DhikrSession(
      id: json['id'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      completedDhikr: (json['completedDhikr'] as List? ?? [])
          .map((progress) => DhikrProgress.fromJson(progress))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'completedDhikr': completedDhikr.map((progress) => progress.toJson()).toList(),
      'totalCount': totalCount,
      'durationSeconds': duration.inSeconds,
    };
  }
}

class DhikrSettings {
  final double textSize;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final bool autoPlayAudio;
  final bool hapticFeedback;
  final bool nightMode;
  final CounterDirection counterDirection;
  final bool showProgress;

  DhikrSettings({
    required this.textSize,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.autoPlayAudio,
    required this.hapticFeedback,
    required this.nightMode,
    required this.counterDirection,
    required this.showProgress,
  });

  DhikrSettings copyWith({
    double? textSize,
    bool? showArabic,
    bool? showTransliteration,
    bool? showTranslation,
    bool? autoPlayAudio,
    bool? hapticFeedback,
    bool? nightMode,
    CounterDirection? counterDirection,
    bool? showProgress,
  }) {
    return DhikrSettings(
      textSize: textSize ?? this.textSize,
      showArabic: showArabic ?? this.showArabic,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      showTranslation: showTranslation ?? this.showTranslation,
      autoPlayAudio: autoPlayAudio ?? this.autoPlayAudio,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      nightMode: nightMode ?? this.nightMode,
      counterDirection: counterDirection ?? this.counterDirection,
      showProgress: showProgress ?? this.showProgress,
    );
  }
} 