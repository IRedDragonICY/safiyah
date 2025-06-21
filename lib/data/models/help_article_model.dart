import 'package:json_annotation/json_annotation.dart';

part 'help_article_model.g.dart';

@JsonSerializable()
class HelpArticle {
  final String id;
  final String title;
  final String content;
  final HelpCategory category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? author;
  final int viewCount;
  final double helpfulRating;
  final List<String> relatedArticleIds;
  final List<HelpSection> sections;
  final String? videoUrl;
  final List<String>? imageUrls;
  final bool isPopular;
  final bool isFeatured;

  HelpArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.viewCount = 0,
    this.helpfulRating = 0.0,
    this.relatedArticleIds = const [],
    this.sections = const [],
    this.videoUrl,
    this.imageUrls,
    this.isPopular = false,
    this.isFeatured = false,
  });

  factory HelpArticle.fromJson(Map<String, dynamic> json) =>
      _$HelpArticleFromJson(json);
  Map<String, dynamic> toJson() => _$HelpArticleToJson(this);
}

@JsonSerializable()
class HelpCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String? parentId;
  final int order;
  final List<HelpCategory> subcategories;

  HelpCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.parentId,
    required this.order,
    this.subcategories = const [],
  });

  factory HelpCategory.fromJson(Map<String, dynamic> json) =>
      _$HelpCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$HelpCategoryToJson(this);
}

@JsonSerializable()
class HelpSection {
  final String title;
  final String content;
  final SectionType type;
  final Map<String, dynamic>? metadata;

  HelpSection({
    required this.title,
    required this.content,
    required this.type,
    this.metadata,
  });

  factory HelpSection.fromJson(Map<String, dynamic> json) =>
      _$HelpSectionFromJson(json);
  Map<String, dynamic> toJson() => _$HelpSectionToJson(this);
}

enum SectionType {
  text,
  steps,
  faq,
  warning,
  tip,
  code,
  table,
}

@JsonSerializable()
class FAQ {
  final String id;
  final String question;
  final String answer;
  final int order;
  final List<String> relatedArticleIds;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
    this.relatedArticleIds = const [],
  });

  factory FAQ.fromJson(Map<String, dynamic> json) => _$FAQFromJson(json);
  Map<String, dynamic> toJson() => _$FAQToJson(this);
}

// Predefined help categories
class HelpCategories {
  static final payment = HelpCategory(
    id: 'payment',
    name: 'Payment & Billing',
    description: 'Payment methods, refunds, and billing issues',
    icon: 'payment',
    order: 1,
  );

  static final booking = HelpCategory(
    id: 'booking',
    name: 'Booking & Reservations',
    description: 'How to book, modify, or cancel reservations',
    icon: 'calendar_today',
    order: 2,
  );

  static final account = HelpCategory(
    id: 'account',
    name: 'Account & Settings',
    description: 'Manage your account and preferences',
    icon: 'person',
    order: 3,
  );

  static final transportation = HelpCategory(
    id: 'transportation',
    name: 'Transportation',
    description: 'Flights, trains, buses, and other transport',
    icon: 'directions_car',
    order: 4,
  );

  static final hajjUmroh = HelpCategory(
    id: 'hajj_umroh',
    name: 'Hajj & Umroh',
    description: 'Pilgrimage packages and guidance',
    icon: 'mosque',
    order: 5,
  );

  static final accessibility = HelpCategory(
    id: 'accessibility',
    name: 'Accessibility',
    description: 'Features for users with disabilities',
    icon: 'accessibility',
    order: 6,
  );

  static final technical = HelpCategory(
    id: 'technical',
    name: 'Technical Support',
    description: 'App issues and troubleshooting',
    icon: 'build',
    order: 7,
  );

  static final safety = HelpCategory(
    id: 'safety',
    name: 'Safety & Security',
    description: 'Your safety and data protection',
    icon: 'security',
    order: 8,
  );

  static List<HelpCategory> all = [
    payment,
    booking,
    account,
    transportation,
    hajjUmroh,
    accessibility,
    technical,
    safety,
  ];
} 