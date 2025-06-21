import 'quran_model.dart';

class IslamicBookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final BookCategory category;
  final String coverImageUrl;
  final List<BookChapter> chapters;
  final String language;
  final int totalPages;
  final double rating;
  final int totalReviews;
  final bool isDownloaded;
  final bool isFavorite;
  final DateTime publishedDate;
  final List<String> tags;

  IslamicBookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.coverImageUrl,
    required this.chapters,
    required this.language,
    required this.totalPages,
    required this.rating,
    required this.totalReviews,
    this.isDownloaded = false,
    this.isFavorite = false,
    required this.publishedDate,
    required this.tags,
  });

  factory IslamicBookModel.fromJson(Map<String, dynamic> json) {
    return IslamicBookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      category: BookCategory.values.firstWhere(
        (cat) => cat.toString().split('.').last == json['category'],
        orElse: () => BookCategory.general,
      ),
      coverImageUrl: json['coverImageUrl'] ?? '',
      chapters: (json['chapters'] as List? ?? [])
          .map((chapter) => BookChapter.fromJson(chapter))
          .toList(),
      language: json['language'] ?? 'English',
      totalPages: json['totalPages'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isDownloaded: json['isDownloaded'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      publishedDate: DateTime.parse(json['publishedDate']),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'category': category.toString().split('.').last,
      'coverImageUrl': coverImageUrl,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      'language': language,
      'totalPages': totalPages,
      'rating': rating,
      'totalReviews': totalReviews,
      'isDownloaded': isDownloaded,
      'isFavorite': isFavorite,
      'publishedDate': publishedDate.toIso8601String(),
      'tags': tags,
    };
  }

  IslamicBookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    BookCategory? category,
    String? coverImageUrl,
    List<BookChapter>? chapters,
    String? language,
    int? totalPages,
    double? rating,
    int? totalReviews,
    bool? isDownloaded,
    bool? isFavorite,
    DateTime? publishedDate,
    List<String>? tags,
  }) {
    return IslamicBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      category: category ?? this.category,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      chapters: chapters ?? this.chapters,
      language: language ?? this.language,
      totalPages: totalPages ?? this.totalPages,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isFavorite: isFavorite ?? this.isFavorite,
      publishedDate: publishedDate ?? this.publishedDate,
      tags: tags ?? this.tags,
    );
  }
}

enum BookCategory {
  prophetsStories,
  companionsStories,
  islamicHistory,
  motivational,
  spirituality,
  fiqh,
  aqidah,
  seerah,
  biography,
  general,
  children,
  youth,
  women,
  family,
  ethics,
}

class BookChapter {
  final int number;
  final String title;
  final String content;
  final int pageStart;
  final int pageEnd;
  final Duration estimatedReadTime;

  BookChapter({
    required this.number,
    required this.title,
    required this.content,
    required this.pageStart,
    required this.pageEnd,
    required this.estimatedReadTime,
  });

  factory BookChapter.fromJson(Map<String, dynamic> json) {
    return BookChapter(
      number: json['number'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      pageStart: json['pageStart'] ?? 0,
      pageEnd: json['pageEnd'] ?? 0,
      estimatedReadTime: Duration(minutes: json['estimatedReadTimeMinutes'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'content': content,
      'pageStart': pageStart,
      'pageEnd': pageEnd,
      'estimatedReadTimeMinutes': estimatedReadTime.inMinutes,
    };
  }
}

class ReadingBookProgress {
  final String bookId;
  final int currentChapter;
  final int currentPage;
  final double progressPercentage;
  final DateTime lastReadTime;
  final Duration totalReadTime;
  final List<BookmarkModel> bookmarks;
  final List<BookNote> notes;

  ReadingBookProgress({
    required this.bookId,
    required this.currentChapter,
    required this.currentPage,
    required this.progressPercentage,
    required this.lastReadTime,
    required this.totalReadTime,
    required this.bookmarks,
    required this.notes,
  });

  factory ReadingBookProgress.fromJson(Map<String, dynamic> json) {
    return ReadingBookProgress(
      bookId: json['bookId'] ?? '',
      currentChapter: json['currentChapter'] ?? 1,
      currentPage: json['currentPage'] ?? 1,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      lastReadTime: DateTime.parse(json['lastReadTime']),
      totalReadTime: Duration(minutes: json['totalReadTimeMinutes'] ?? 0),
      bookmarks: (json['bookmarks'] as List? ?? [])
          .map((bookmark) => BookmarkModel.fromJson(bookmark))
          .toList(),
      notes: (json['notes'] as List? ?? [])
          .map((note) => BookNote.fromJson(note))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'currentChapter': currentChapter,
      'currentPage': currentPage,
      'progressPercentage': progressPercentage,
      'lastReadTime': lastReadTime.toIso8601String(),
      'totalReadTimeMinutes': totalReadTime.inMinutes,
      'bookmarks': bookmarks.map((bookmark) => bookmark.toJson()).toList(),
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }
}

class BookNote {
  final String id;
  final String bookId;
  final int chapter;
  final int page;
  final String content;
  final DateTime createdAt;
  final String? color;

  BookNote({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.page,
    required this.content,
    required this.createdAt,
    this.color,
  });

  factory BookNote.fromJson(Map<String, dynamic> json) {
    return BookNote(
      id: json['id'] ?? '',
      bookId: json['bookId'] ?? '',
      chapter: json['chapter'] ?? 0,
      page: json['page'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'page': page,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
    };
  }
} 