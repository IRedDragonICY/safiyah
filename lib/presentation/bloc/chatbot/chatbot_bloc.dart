import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/data/repositories/chatbot_repository.dart';
import 'package:safiyah/core/services/ai_tools_service.dart';
import 'package:uuid/uuid.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _chatbotRepository;
  final AIToolsService _aiToolsService = AIToolsService();
  final Uuid _uuid = const Uuid();

  ChatbotBloc({required ChatbotRepository chatbotRepository})
      : _chatbotRepository = chatbotRepository,
        super(ChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<StartNewChat>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<SendSuggestedQuestion>(_onSendSuggestedQuestion);
    on<UploadAttachment>(_onUploadAttachment);
    on<RemoveAttachment>(_onRemoveAttachment);
    on<ExecuteTool>(_onExecuteTool);
    on<NavigateFromTool>(_onNavigateFromTool);
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
      attachments: event.attachments,
    );

    final updatedMessages = List<ChatMessageModel>.from(state.messages)..insert(0, userMessage);
    emit(ChatLoading(messages: updatedMessages));

    // Check if this is a tool-related request
    final toolType = _detectToolFromMessage(event.text);
    if (toolType != ToolType.none) {
      add(ExecuteTool(
        toolType: toolType,
        parameters: _extractParametersFromMessage(event.text, toolType),
      ));
      return;
    }

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

  void _onSendSuggestedQuestion(SendSuggestedQuestion event, Emitter<ChatbotState> emit) {
    add(SendMessage(text: event.question));
  }

  void _onUploadAttachment(UploadAttachment event, Emitter<ChatbotState> emit) {
    // This would typically be handled in the UI layer
    // Here we could process the attachment if needed
  }

  void _onRemoveAttachment(RemoveAttachment event, Emitter<ChatbotState> emit) {
    // This would typically be handled in the UI layer
    // Here we could remove the attachment if needed
  }

  Future<void> _onExecuteTool(ExecuteTool event, Emitter<ChatbotState> emit) async {
    try {
      final result = await _aiToolsService.executeTool(event.toolType, event.parameters);
      
      final toolCall = ToolCall(
        toolType: event.toolType,
        parameters: event.parameters,
        result: result,
        navigationRoute: result['navigationRoute'] as String?,
      );

      final botMessage = ChatMessageModel(
        id: _uuid.v4(),
        text: _generateToolResponseText(event.toolType, result),
        sender: Sender.bot,
        timestamp: DateTime.now(),
        toolCall: toolCall,
        suggestedQuestions: _generateSuggestedQuestions(event.toolType, result),
      );

      final updatedMessages = List<ChatMessageModel>.from(state.messages)..insert(0, botMessage);
      emit(ChatLoaded(messages: updatedMessages));
    } catch (e) {
      emit(ChatError(message: "Sorry, I couldn't complete that action."));
    }
  }

  void _onNavigateFromTool(NavigateFromTool event, Emitter<ChatbotState> emit) {
    // This would typically trigger navigation in the UI layer
    // The navigation is handled by the UI when this event is dispatched
  }

  void _onRegenerateResponse(RegenerateResponse event, Emitter<ChatbotState> emit) async {
      if (state.messages.length < 2) return;

      final lastUserMessage = state.messages.firstWhere((m) => m.sender == Sender.user, orElse: () => state.messages[1]);

      final messagesWithoutLastBotResponse = state.messages.where((m) => m.id != event.messageId).toList();
      emit(ChatLoaded(messages: messagesWithoutLastBotResponse));

      add(SendMessage(text: lastUserMessage.text));
  }

  String _generateToolResponseText(ToolType toolType, Map<String, dynamic> result) {
    switch (toolType) {
      case ToolType.hotelSearch:
        final hotels = result['hotels'] as List? ?? [];
        return "I found ${hotels.length} hotels for you. Here are the top options:";
      case ToolType.purchaseHistory:
        final purchases = result['purchases'] as List? ?? [];
        return "Here's your purchase history. You have ${purchases.length} transactions:";
      case ToolType.prayerTime:
        return "Here are today's prayer times for your location:";
      case ToolType.currencyConverter:
        return "Here's the currency conversion:";
      case ToolType.itineraryCreator:
        final days = result['days'] ?? 0;
        return "I've created a $days-day itinerary for you:";
      case ToolType.placeSearch:
        final places = result['places'] as List? ?? [];
        return "I found ${places.length} places that match your criteria:";
      case ToolType.weatherCheck:
        return "Here's the weather information:";
      case ToolType.voucherSearch:
        final vouchers = result['vouchers'] as List? ?? [];
        return "I found ${vouchers.length} available vouchers for you:";
      default:
        return "I've completed that action for you.";
    }
  }

  List<String> _generateSuggestedQuestions(ToolType toolType, Map<String, dynamic> result) {
    switch (toolType) {
      case ToolType.hotelSearch:
        return [
          "Show me more budget options",
          "Find hotels with pools",
          "Check availability for different dates",
        ];
      case ToolType.purchaseHistory:
        return [
          "Show only hotel bookings",
          "Filter by this year",
          "Export my purchase history",
        ];
      case ToolType.prayerTime:
        return [
          "Set prayer reminders",
          "Find nearby mosques",
          "Show Qibla direction",
        ];
      case ToolType.currencyConverter:
        return [
          "Convert to different currency",
          "Show exchange rate trends",
          "Set rate alerts",
        ];
      case ToolType.itineraryCreator:
        return [
          "Add more days to itinerary",
          "Change accommodation type",
          "Include shopping activities",
        ];
      default:
        return [
          "What else can you help with?",
          "Show me more options",
          "Help me with something else",
        ];
    }
  }

  ToolType _detectToolFromMessage(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Hotel search keywords
    if (lowerMessage.contains('hotel') || 
        lowerMessage.contains('accommodation') ||
        lowerMessage.contains('stay') ||
        lowerMessage.contains('booking') ||
        lowerMessage.contains('budget-friendly hotels') ||
        lowerMessage.contains('near masjid al-haram')) {
      return ToolType.hotelSearch;
    }
    
    // Prayer time keywords
    if (lowerMessage.contains('prayer') ||
        lowerMessage.contains('maghrib') ||
        lowerMessage.contains('fajr') ||
        lowerMessage.contains('dhuhr') ||
        lowerMessage.contains('asr') ||
        lowerMessage.contains('isha') ||
        lowerMessage.contains('prayer time')) {
      return ToolType.prayerTime;
    }
    
    // Currency conversion keywords
    if (lowerMessage.contains('convert') ||
        lowerMessage.contains('currency') ||
        lowerMessage.contains('usd') ||
        lowerMessage.contains('riyal') ||
        lowerMessage.contains('exchange rate')) {
      return ToolType.currencyConverter;
    }
    
    // Itinerary keywords
    if (lowerMessage.contains('itinerary') ||
        lowerMessage.contains('plan') ||
        lowerMessage.contains('trip') ||
        lowerMessage.contains('journey') ||
        lowerMessage.contains('create a') ||
        lowerMessage.contains('umrah itinerary')) {
      return ToolType.itineraryCreator;
    }
    
    // Places search keywords
    if (lowerMessage.contains('restaurant') ||
        lowerMessage.contains('halal') ||
        lowerMessage.contains('mosque') ||
        lowerMessage.contains('nearby') ||
        lowerMessage.contains('find') ||
        lowerMessage.contains('place')) {
      return ToolType.placeSearch;
    }
    
    // Weather keywords
    if (lowerMessage.contains('weather') ||
        lowerMessage.contains('temperature') ||
        lowerMessage.contains('forecast') ||
        lowerMessage.contains('medina this week')) {
      return ToolType.weatherCheck;
    }
    
    // Voucher keywords
    if (lowerMessage.contains('voucher') ||
        lowerMessage.contains('discount') ||
        lowerMessage.contains('promotion') ||
        lowerMessage.contains('coupon')) {
      return ToolType.voucherSearch;
    }
    
    // Purchase history keywords
    if (lowerMessage.contains('purchase') ||
        lowerMessage.contains('booking') ||
        lowerMessage.contains('history') ||
        lowerMessage.contains('transaction') ||
        lowerMessage.contains('recent bookings')) {
      return ToolType.purchaseHistory;
    }
    
    return ToolType.none;
  }

  Map<String, dynamic> _extractParametersFromMessage(String message, ToolType toolType) {
    final lowerMessage = message.toLowerCase();
    
    switch (toolType) {
      case ToolType.hotelSearch:
        return {
          'location': lowerMessage.contains('mecca') || lowerMessage.contains('makkah') 
              ? 'Makkah' 
              : lowerMessage.contains('medina') || lowerMessage.contains('madinah')
                  ? 'Madinah'
                  : 'Current Location',
          'budget': lowerMessage.contains('budget') ? 'budget' : 'any',
          'maxPrice': lowerMessage.contains('budget') ? 500 : 1000,
        };
      
      case ToolType.currencyConverter:
        // Extract currency codes and amounts
        final RegExp amountRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(usd|myr|sar)', caseSensitive: false);
        final matches = amountRegex.allMatches(lowerMessage);
        
        double amount = 1000.0;
        String from = 'USD';
        String to = 'SAR';
        
        if (matches.isNotEmpty) {
          final match = matches.first;
          amount = double.tryParse(match.group(1)!) ?? 1000.0;
          from = match.group(2)!.toUpperCase();
        }
        
        if (lowerMessage.contains('to') && lowerMessage.contains('riyal')) {
          to = 'SAR';
        } else if (lowerMessage.contains('to') && lowerMessage.contains('myr')) {
          to = 'MYR';
        }
        
        return {
          'amount': amount,
          'from': from,
          'to': to,
        };
      
      case ToolType.itineraryCreator:
        // Extract number of days
        final RegExp daysRegex = RegExp(r'(\d+)[- ]?day', caseSensitive: false);
        final daysMatch = daysRegex.firstMatch(lowerMessage);
        int days = daysMatch != null ? int.tryParse(daysMatch.group(1)!) ?? 5 : 5;
        
        String destination = 'Makkah';
        if (lowerMessage.contains('medina') || lowerMessage.contains('madinah')) {
          destination = 'Madinah';
        } else if (lowerMessage.contains('umrah')) {
          destination = 'Makkah & Madinah';
        }
        
        return {
          'destination': destination,
          'days': days,
          'interests': ['religious', 'cultural'],
        };
      
      case ToolType.placeSearch:
        String category = 'all';
        if (lowerMessage.contains('restaurant') || lowerMessage.contains('halal')) {
          category = 'restaurant';
        } else if (lowerMessage.contains('mosque')) {
          category = 'mosque';
        } else if (lowerMessage.contains('attraction')) {
          category = 'attraction';
        }
        
        return {
          'query': message,
          'category': category,
          'location': 'nearby',
        };
      
      case ToolType.weatherCheck:
        String location = 'Current Location';
        if (lowerMessage.contains('medina') || lowerMessage.contains('madinah')) {
          location = 'Madinah';
        } else if (lowerMessage.contains('mecca') || lowerMessage.contains('makkah')) {
          location = 'Makkah';
        }
        
        int days = lowerMessage.contains('week') ? 7 : 1;
        
        return {
          'location': location,
          'days': days,
        };
      
      case ToolType.voucherSearch:
        String category = 'all';
        if (lowerMessage.contains('hotel')) {
          category = 'hotel';
        } else if (lowerMessage.contains('hajj') || lowerMessage.contains('umrah')) {
          category = 'hajj';
        } else if (lowerMessage.contains('restaurant')) {
          category = 'restaurant';
        }
        
        return {
          'category': category,
          'minDiscount': 0,
        };
      
      case ToolType.purchaseHistory:
        String category = 'all';
        if (lowerMessage.contains('hotel')) {
          category = 'hotel';
        } else if (lowerMessage.contains('flight')) {
          category = 'flight';
        } else if (lowerMessage.contains('package')) {
          category = 'package';
        }
        
        return {
          'category': category,
        };
      
      default:
        return {};
    }
  }
}
