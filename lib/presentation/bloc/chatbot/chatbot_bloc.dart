import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/data/repositories/chatbot_repository.dart';
import 'package:uuid/uuid.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _chatbotRepository;
  final Uuid _uuid = const Uuid();

  ChatbotBloc({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository,
        super(ChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<StartNewChat>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<EditMessage>(_onEditMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<RegenerateResponse>(_onRegenerateResponse);
  }

  void _onLoadChatHistory(ChatbotEvent event, Emitter<ChatbotState> emit) {
    emit(ChatLoaded(messages: [
      ChatMessageModel(
        id: _uuid.v4(),
        text: "Assalamu'alaikum! I'm Safiyah, your AI travel assistant. How can I help you plan your journey?",
        sender: Sender.bot,
        timestamp: DateTime.now(),
      )
    ]));
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatbotState> emit) async {
    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      text: event.text,
      sender: Sender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessageModel>.from(state.messages)..insert(0, userMessage);
    emit(ChatLoading(messages: updatedMessages));

    final botPlaceholder = ChatMessageModel(
      id: _uuid.v4(),
      text: '',
      sender: Sender.bot,
      timestamp: DateTime.now(),
    );

    var currentMessages = List<ChatMessageModel>.from(state.messages)..insert(0, botPlaceholder);
    emit(ChatLoading(messages: currentMessages));

    try {
      final responseStream = _chatbotRepository.getResponseStream(event.text);
      await for (final chunk in responseStream) {
        currentMessages = List.from(state.messages);
        final currentBotMessage = currentMessages.first;
        final updatedBotMessage = ChatMessageModel(
          id: currentBotMessage.id,
          text: currentBotMessage.text + chunk,
          sender: Sender.bot,
          timestamp: currentBotMessage.timestamp
        );
        currentMessages[0] = updatedBotMessage;
        emit(ChatLoading(messages: currentMessages));
      }

    } catch (e) {
      emit(ChatError(message: "Sorry, I'm having trouble connecting."));
    } finally {
       emit(ChatLoaded(messages: state.messages));
    }
  }

  void _onEditMessage(EditMessage event, Emitter<ChatbotState> emit) {
    final newMessages = state.messages.map((msg) {
      if (msg.id == event.messageId) {
        return ChatMessageModel(
          id: msg.id,
          text: event.newText,
          sender: msg.sender,
          timestamp: msg.timestamp,
        );
      }
      return msg;
    }).toList();
    emit(ChatLoaded(messages: newMessages));
  }

  void _onDeleteMessage(DeleteMessage event, Emitter<ChatbotState> emit) {
    final newMessages = state.messages.where((msg) => msg.id != event.messageId).toList();
    emit(ChatLoaded(messages: newMessages));
  }

  void _onRegenerateResponse(RegenerateResponse event, Emitter<ChatbotState> emit) async {
      if (state.messages.length < 2) return;

      final lastUserMessage = state.messages.firstWhere((m) => m.sender == Sender.user, orElse: () => state.messages[1]);

      final messagesWithoutLastBotResponse = state.messages.where((m) => m.id != event.messageId).toList();
      emit(ChatLoaded(messages: messagesWithoutLastBotResponse));

      add(SendMessage(text: lastUserMessage.text));
  }
}