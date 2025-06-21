class HadithModel {
  final String id;
  final String collection; // Bukhari, Muslim, Tirmidhi, etc.
  final String book;
  final int number;
  final String arabicText;
  final String englishText;
  final String indonesianText;
  final String narrator;
  final String chain; // Sanad
  final String grade; // Sahih, Hasan, Daif
  final List<String> keywords;
  final List<String> themes;
  final bool isFavorite;
  final String reference;
  final DateTime? dateAdded;

  HadithModel({
    required this.id,
    required this.collection,
    required this.book,
    required this.number,
    required this.arabicText,
    required this.englishText,
    required this.indonesianText,
    required this.narrator,
    required this.chain,
    required this.grade,
    required this.keywords,
    required this.themes,
    required this.reference,
    this.isFavorite = false,
    this.dateAdded,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] ?? '',
      collection: json['collection'] ?? '',
      book: json['book'] ?? '',
      number: json['number'] ?? 0,
      arabicText: json['arabicText'] ?? '',
      englishText: json['englishText'] ?? '',
      indonesianText: json['indonesianText'] ?? '',
      narrator: json['narrator'] ?? '',
      chain: json['chain'] ?? '',
      grade: json['grade'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      themes: List<String>.from(json['themes'] ?? []),
      reference: json['reference'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      dateAdded: json['dateAdded'] != null ? DateTime.parse(json['dateAdded']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'book': book,
      'number': number,
      'arabicText': arabicText,
      'englishText': englishText,
      'indonesianText': indonesianText,
      'narrator': narrator,
      'chain': chain,
      'grade': grade,
      'keywords': keywords,
      'themes': themes,
      'reference': reference,
      'isFavorite': isFavorite,
      'dateAdded': dateAdded?.toIso8601String(),
    };
  }

  HadithModel copyWith({
    String? id,
    String? collection,
    String? book,
    int? number,
    String? arabicText,
    String? englishText,
    String? indonesianText,
    String? narrator,
    String? chain,
    String? grade,
    List<String>? keywords,
    List<String>? themes,
    bool? isFavorite,
    String? reference,
    DateTime? dateAdded,
  }) {
    return HadithModel(
      id: id ?? this.id,
      collection: collection ?? this.collection,
      book: book ?? this.book,
      number: number ?? this.number,
      arabicText: arabicText ?? this.arabicText,
      englishText: englishText ?? this.englishText,
      indonesianText: indonesianText ?? this.indonesianText,
      narrator: narrator ?? this.narrator,
      chain: chain ?? this.chain,
      grade: grade ?? this.grade,
      keywords: keywords ?? this.keywords,
      themes: themes ?? this.themes,
      reference: reference ?? this.reference,
      isFavorite: isFavorite ?? this.isFavorite,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

class HadithCollection {
  final String name;
  final String arabicName;
  final String description;
  final String compiler;
  final int totalHadith;
  final List<HadithBook> books;

  HadithCollection({
    required this.name,
    required this.arabicName,
    required this.description,
    required this.compiler,
    required this.totalHadith,
    required this.books,
  });

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      description: json['description'] ?? '',
      compiler: json['compiler'] ?? '',
      totalHadith: json['totalHadith'] ?? 0,
      books: (json['books'] as List? ?? [])
          .map((book) => HadithBook.fromJson(book))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabicName': arabicName,
      'description': description,
      'compiler': compiler,
      'totalHadith': totalHadith,
      'books': books.map((book) => book.toJson()).toList(),
    };
  }
}

class HadithBook {
  final String name;
  final String arabicName;
  final int number;
  final int hadithCount;
  final List<String> chapters;

  HadithBook({
    required this.name,
    required this.arabicName,
    required this.number,
    required this.hadithCount,
    required this.chapters,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      number: json['number'] ?? 0,
      hadithCount: json['hadithCount'] ?? 0,
      chapters: List<String>.from(json['chapters'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabicName': arabicName,
      'number': number,
      'hadithCount': hadithCount,
      'chapters': chapters,
    };
  }
}

class HadithSettings {
  final double textSize;
  final bool showArabic;
  final bool showEnglish;
  final bool showIndonesian;
  final bool showNarrator;
  final bool showChain;
  final bool showGrade;
  final bool nightMode;
  final String preferredTranslation;
  final bool autoScroll;

  HadithSettings({
    required this.textSize,
    required this.showArabic,
    required this.showEnglish,
    required this.showIndonesian,
    required this.showNarrator,
    required this.showChain,
    required this.showGrade,
    required this.nightMode,
    required this.preferredTranslation,
    required this.autoScroll,
  });

  HadithSettings copyWith({
    double? textSize,
    bool? showArabic,
    bool? showEnglish,
    bool? showIndonesian,
    bool? showNarrator,
    bool? showChain,
    bool? showGrade,
    bool? nightMode,
    String? preferredTranslation,
    bool? autoScroll,
  }) {
    return HadithSettings(
      textSize: textSize ?? this.textSize,
      showArabic: showArabic ?? this.showArabic,
      showEnglish: showEnglish ?? this.showEnglish,
      showIndonesian: showIndonesian ?? this.showIndonesian,
      showNarrator: showNarrator ?? this.showNarrator,
      showChain: showChain ?? this.showChain,
      showGrade: showGrade ?? this.showGrade,
      nightMode: nightMode ?? this.nightMode,
      preferredTranslation: preferredTranslation ?? this.preferredTranslation,
      autoScroll: autoScroll ?? this.autoScroll,
    );
  }
} 