import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_bloc.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_event.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_state.dart';
import 'package:safiyah/presentation/widgets/chatbot/chat_message_bubble.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(LoadChatHistory());
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      context
          .read<ChatbotBloc>()
          .add(SendMessage(text: _textController.text.trim()));
      _textController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safiyah AI Assistant'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () {
              context.read<ChatbotBloc>().add(StartNewChat());
            },
            tooltip: 'New Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatbotBloc, ChatbotState>(
              listener: (context, state) {
                if (state.messages.isNotEmpty) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatLoading && state.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                if (state.messages.length <= 1 && state is! ChatLoading) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessageBubble(message: state.messages[index]);
                  },
                );
              },
            ),
          ),
          _buildChatInput(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            'What can I help with?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildStarterPrompts(context),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.3)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const Spacer(),
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildStarterPrompts(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2
      ),
      children: [
          _buildSuggestionChip(
            context,
            icon: Icons.map_outlined,
            text: 'Plan Itinerary',
            onTap: () {
              _textController.text = 'Create a travel itinerary for 5 days in Tokyo';
              _sendMessage();
            }
          ),
          _buildSuggestionChip(
            context,
            icon: Icons.calculate_outlined,
            text: 'Calculate Budget',
            onTap: () {
               _textController.text = 'Estimate a budget for a 3-day trip to Mecca';
              _sendMessage();
            }
          ),
          _buildSuggestionChip(
            context,
            icon: Icons.lightbulb_outline,
            text: 'Brainstorm Activities',
            onTap: () {
               _textController.text = 'Brainstorm some Halal-friendly activities in Kuala Lumpur';
              _sendMessage();
            }
          ),
          _buildSuggestionChip(
            context,
            icon: Icons.image_search_outlined,
            text: 'Find from Image',
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image analysis feature is coming soon!')));
            }
          ),
      ],
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Material(
      elevation: 8.0,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image upload feature is coming soon!')));
                },
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Ask Safiyah anything...',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic_none_outlined),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice input feature is coming soon!')));
                },
              ),
              IconButton(
                icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
