import 'package:equatable/equatable.dart';

enum Sender { user, bot }

enum AttachmentType { image, document, none }

enum ToolType {
  none,
  hotelSearch,
  purchaseHistory,
  navigation,
  prayerTime,
  currencyConverter,
  itineraryCreator,
  placeSearch,
  weatherCheck,
  voucherSearch,
}

class Attachment extends Equatable {
  final String id;
  final String url;
  final AttachmentType type;
  final String? fileName;
  final int? fileSize;

  const Attachment({
    required this.id,
    required this.url,
    required this.type,
    this.fileName,
    this.fileSize,
  });

  @override
  List<Object?> get props => [id, url, type, fileName, fileSize];
}

class ToolCall extends Equatable {
  final ToolType toolType;
  final Map<String, dynamic> parameters;
  final Map<String, dynamic>? result;
  final String? navigationRoute;

  const ToolCall({
    required this.toolType,
    required this.parameters,
    this.result,
    this.navigationRoute,
  });

  @override
  List<Object?> get props => [toolType, parameters, result, navigationRoute];
}

class ChatMessageModel extends Equatable {
  final String id;
  final String text;
  final Sender sender;
  final DateTime? timestamp;
  final List<Attachment> attachments;
  final List<String> suggestedQuestions;
  final ToolCall? toolCall;
  final bool isTyping;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    this.timestamp,
    this.attachments = const [],
    this.suggestedQuestions = const [],
    this.toolCall,
    this.isTyping = false,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    Sender? sender,
    DateTime? timestamp,
    List<Attachment>? attachments,
    List<String>? suggestedQuestions,
    ToolCall? toolCall,
    bool? isTyping,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      suggestedQuestions: suggestedQuestions ?? this.suggestedQuestions,
      toolCall: toolCall ?? this.toolCall,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        sender,
        timestamp,
        attachments,
        suggestedQuestions,
        toolCall,
        isTyping
      ];
}
