// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpArticle _$HelpArticleFromJson(Map<String, dynamic> json) => HelpArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: HelpCategory.fromJson(json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      author: json['author'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      helpfulRating: (json['helpfulRating'] as num?)?.toDouble() ?? 0.0,
      relatedArticleIds: (json['relatedArticleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => HelpSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      videoUrl: json['videoUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isPopular: json['isPopular'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );

Map<String, dynamic> _$HelpArticleToJson(HelpArticle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'author': instance.author,
      'viewCount': instance.viewCount,
      'helpfulRating': instance.helpfulRating,
      'relatedArticleIds': instance.relatedArticleIds,
      'sections': instance.sections,
      'videoUrl': instance.videoUrl,
      'imageUrls': instance.imageUrls,
      'isPopular': instance.isPopular,
      'isFeatured': instance.isFeatured,
    };

HelpCategory _$HelpCategoryFromJson(Map<String, dynamic> json) => HelpCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      parentId: json['parentId'] as String?,
      order: (json['order'] as num).toInt(),
      subcategories: (json['subcategories'] as List<dynamic>?)
              ?.map((e) => HelpCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HelpCategoryToJson(HelpCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'order': instance.order,
      'subcategories': instance.subcategories,
    };

HelpSection _$HelpSectionFromJson(Map<String, dynamic> json) => HelpSection(
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$SectionTypeEnumMap, json['type']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HelpSectionToJson(HelpSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'type': _$SectionTypeEnumMap[instance.type]!,
      'metadata': instance.metadata,
    };

const _$SectionTypeEnumMap = {
  SectionType.text: 'text',
  SectionType.steps: 'steps',
  SectionType.faq: 'faq',
  SectionType.warning: 'warning',
  SectionType.tip: 'tip',
  SectionType.code: 'code',
  SectionType.table: 'table',
};

FAQ _$FAQFromJson(Map<String, dynamic> json) => FAQ(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      order: (json['order'] as num).toInt(),
      relatedArticleIds: (json['relatedArticleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FAQToJson(FAQ instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'order': instance.order,
      'relatedArticleIds': instance.relatedArticleIds,
    };
