import 'package:equatable/equatable.dart';
import 'package:safiyah/data/models/chat_message_model.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatbotEvent {}

class StartNewChat extends ChatbotEvent {}

class SendMessage extends ChatbotEvent {
  final String text;
  final List<Attachment> attachments;
  
  const SendMessage({
    required this.text,
    this.attachments = const [],
  });

  @override
  List<Object> get props => [text, attachments];
}

class SendSuggestedQuestion extends ChatbotEvent {
  final String question;
  const SendSuggestedQuestion({required this.question});

  @override
  List<Object> get props => [question];
}

class UploadAttachment extends ChatbotEvent {
  final String filePath;
  final AttachmentType type;
  
  const UploadAttachment({
    required this.filePath,
    required this.type,
  });

  @override
  List<Object> get props => [filePath, type];
}

class RemoveAttachment extends ChatbotEvent {
  final String attachmentId;
  const RemoveAttachment({required this.attachmentId});

  @override
  List<Object> get props => [attachmentId];
}

class ExecuteTool extends ChatbotEvent {
  final ToolType toolType;
  final Map<String, dynamic> parameters;
  
  const ExecuteTool({
    required this.toolType,
    required this.parameters,
  });

  @override
  List<Object> get props => [toolType, parameters];
}

class NavigateFromTool extends ChatbotEvent {
  final String route;
  final Map<String, dynamic>? parameters;
  
  const NavigateFromTool({
    required this.route,
    this.parameters,
  });

  @override
  List<Object> get props => [route, parameters ?? {}];
}

class EditMessage extends ChatbotEvent {
  final String messageId;
  final String newText;

  const EditMessage({required this.messageId, required this.newText});

  @override
  List<Object> get props => [messageId, newText];
}

class DeleteMessage extends ChatbotEvent {
  final String messageId;
  const DeleteMessage({required this.messageId});

  @override
  List<Object> get props => [messageId];
}

class RegenerateResponse extends ChatbotEvent {
    final String messageId;
    const RegenerateResponse({required this.messageId});

    @override
    List<Object> get props => [messageId];
}
