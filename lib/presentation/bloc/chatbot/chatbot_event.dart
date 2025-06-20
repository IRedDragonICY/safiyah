import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatbotEvent {}

class StartNewChat extends ChatbotEvent {}

class SendMessage extends ChatbotEvent {
  final String text;
  const SendMessage({required this.text});

  @override
  List<Object> get props => [text];
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
