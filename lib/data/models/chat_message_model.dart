import 'package:equatable/equatable.dart';

enum Sender { user, bot }

class ChatMessageModel extends Equatable {
  final String id;
  final String text;
  final Sender sender;
  final DateTime? timestamp;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    this.timestamp,
  });

  @override
  List<Object?> get props => [id, text, sender, timestamp];
}