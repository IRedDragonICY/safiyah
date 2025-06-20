import 'dart:async';
import 'package:uuid/uuid.dart';

class ChatbotRepository {
  final Uuid _uuid = const Uuid();

  Stream<String> getResponseStream(String userMessage) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    String responseText;
    final lowerCaseMessage = userMessage.toLowerCase();

    if (lowerCaseMessage.contains('itinerary') || lowerCaseMessage.contains('plan') || lowerCaseMessage.contains('tokyo')) {
      responseText =
          'Of course! For your trip to Tokyo, I suggest a 5-day itinerary: Day 1, explore vibrant Shinjuku. Day 2, visit the beautiful Tokyo Camii Mosque. Day 3 is for culture in Asakusa. Day 4, a scenic day trip to Hakone. Finally, day 5 for shopping in Shibuya. Interested in more details for any day?';
    } else if (lowerCaseMessage.contains('halal') || lowerCaseMessage.contains('restaurant')) {
      responseText =
          "I've found three highly-rated halal restaurants near you: 'Halal Ramen Ouka', 'Gyumon Shibuya', and 'CoCoICHI Curry House Halal Akihabara'.";
    } else if (lowerCaseMessage.contains('budget') || lowerCaseMessage.contains('cost') || lowerCaseMessage.contains('mecca')) {
      responseText =
          "A moderate budget for a 3-day trip to Mecca, excluding flights, would be around \$500-\$700 per person. This covers accommodation, food, and local transport. This can vary greatly depending on your travel style.";
    } else if (lowerCaseMessage.contains('weather') || lowerCaseMessage.contains('kuala lumpur')) {
      responseText =
          "The weather in Kuala Lumpur is currently 32°C and partly cloudy. It's a great day to explore the city!";
    } else if (lowerCaseMessage.contains('hello') || lowerCaseMessage.contains('hi')) {
      responseText = "Assalamu'alaikum! How can I assist you with your travel plans today?";
    } else {
      responseText =
          "I'm sorry, I'm still learning. I can help with itineraries, finding halal places, and travel budgets. How can I help?";
    }

    final words = responseText.split(' ');
    for (final word in words) {
      yield '$word ';
      await Future.delayed(const Duration(milliseconds: 60));
    }
  }
}
