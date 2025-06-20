import 'package:equatable/equatable.dart';
import 'package:safiyah/data/models/chat_message_model.dart';

abstract class ChatbotState extends Equatable {
  final List<ChatMessageModel> messages;
  const ChatbotState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatInitial extends ChatbotState {
  ChatInitial() : super(messages: []);
}

class ChatLoading extends ChatbotState {
  const ChatLoading({required super.messages});
}

class ChatLoaded extends ChatbotState {
  const ChatLoaded({required super.messages});
}

class ChatError extends ChatbotState {
  final String message;
  const ChatError({required this.message}) : super(messages: const []);

  @override
  List<Object> get props => [message];
}
