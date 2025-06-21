import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_bloc.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_event.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_state.dart';
import 'package:safiyah/presentation/widgets/chatbot/chat_message_bubble.dart';
import 'package:safiyah/presentation/widgets/chatbot/attachment_preview.dart';
import 'package:safiyah/presentation/pages/chatbot/chat_history_page.dart';
import 'package:safiyah/presentation/pages/chatbot/realtime_chatbot_page.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Attachment> _pendingAttachments = [];
  
  late AnimationController _fabAnimationController;
  late AnimationController _suggestionAnimationController;
  
  // Suggestion pools for gacha system
  final List<Map<String, dynamic>> _suggestionPools = [
    {
      'icon': Icons.mosque,
      'text': 'Find nearby mosques',
      'query': 'Show me the nearest mosques to my location',
    },
    {
      'icon': Icons.calendar_today,
      'text': 'Plan Hajj journey',
      'query': 'Help me plan my Hajj journey step by step',
    },
    {
      'icon': Icons.hotel,
      'text': 'Budget hotels in Mecca',
      'query': 'Find budget-friendly hotels near Masjid al-Haram',
    },
    {
      'icon': Icons.restaurant,
      'text': 'Halal restaurants',
      'query': 'Recommend halal restaurants with good reviews',
    },
    {
      'icon': Icons.attach_money,
      'text': 'Convert currency',
      'query': 'Convert 1000 USD to Saudi Riyal',
    },
    {
      'icon': Icons.wb_sunny,
      'text': 'Weather forecast',
      'query': 'What\'s the weather like in Medina this week?',
    },
    {
      'icon': Icons.map,
      'text': 'Create itinerary',
      'query': 'Create a 5-day Umrah itinerary for me',
    },
    {
      'icon': Icons.local_offer,
      'text': 'Find vouchers',
      'query': 'Show me available discount vouchers',
    },
    {
      'icon': Icons.flight,
      'text': 'Flight deals',
      'query': 'Find cheap flights to Saudi Arabia',
    },
    {
      'icon': Icons.shopping_bag,
      'text': 'Shopping guide',
      'query': 'What should I buy as souvenirs from Mecca?',
    },
    {
      'icon': Icons.medical_services,
      'text': 'Travel insurance',
      'query': 'Compare travel insurance plans for Hajj',
    },
    {
      'icon': Icons.directions_walk,
      'text': 'Walking routes',
      'query': 'Best walking routes around the Haram',
    },
  ];

  List<Map<String, dynamic>> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(LoadChatHistory());
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _suggestionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _textController.addListener(() {
      setState(() {});
    });
    
    _refreshSuggestions();
  }

  void _refreshSuggestions() {
    // Gacha system - randomly select 4 suggestions
    final random = math.Random();
    final shuffled = List<Map<String, dynamic>>.from(_suggestionPools)..shuffle(random);
    setState(() {
      _currentSuggestions = shuffled.take(4).toList();
    });
    _suggestionAnimationController.forward(from: 0);
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty || _pendingAttachments.isNotEmpty) {
      context.read<ChatbotBloc>().add(SendMessage(
        text: _textController.text.trim(),
        attachments: List.from(_pendingAttachments),
      ));
      _textController.clear();
      setState(() {
        _pendingAttachments.clear();
      });
      _scrollToBottom();
    }
  }

  void _handleSuggestedQuestion(String question) {
    context.read<ChatbotBloc>().add(SendSuggestedQuestion(question: question));
    _scrollToBottom();
  }

  void _handleCopyMessage(ChatMessageModel message) {
    Clipboard.setData(ClipboardData(text: message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleShareMessage(ChatMessageModel message) {
    // Simple share implementation using clipboard for now
    Clipboard.setData(ClipboardData(text: message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied. You can paste it anywhere to share.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleLikeMessage(ChatMessageModel message) {
    // Here you would typically send feedback to your analytics/ML system
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.thumb_up, color: Colors.green, size: 16),
            SizedBox(width: 8),
            Text('Thanks for your feedback!'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  void _handleDislikeMessage(ChatMessageModel message) {
    // Here you would typically send feedback to your analytics/ML system
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.thumb_down, color: Colors.orange, size: 16),
            SizedBox(width: 8),
            Text('Feedback noted. I\'ll try to improve!'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  void _handleRegenerateMessage(ChatMessageModel message) {
    context.read<ChatbotBloc>().add(RegenerateResponse(messageId: message.id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Regenerating response...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEditMessage(ChatMessageModel message) {
    showDialog(
      context: context,
      builder: (context) {
        final editController = TextEditingController(text: message.text);
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Enter your message...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newText = editController.text.trim();
                if (newText.isNotEmpty && newText != message.text) {
                  context.read<ChatbotBloc>().add(
                    EditMessage(messageId: message.id, newText: newText),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message updated!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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

  void _navigateToRealtimeChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RealtimeChatbotPage()),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      setState(() {
        _pendingAttachments.add(Attachment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: 'file://${image.path}',
          type: AttachmentType.image,
          fileName: image.name,
        ));
      });
    }
  }

  Future<void> _pickDocument() async {
    // TODO: Implement file picker when dependency is available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document upload coming soon!'),
      ),
    );
    
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'],
    // );

    // if (result != null && result.files.single.path != null) {
    //   setState(() {
    //     _pendingAttachments.add(Attachment(
    //       id: DateTime.now().millisecondsSinceEpoch.toString(),
    //       url: 'file://${result.files.single.path}',
    //       type: AttachmentType.document,
    //       fileName: result.files.single.name,
    //       fileSize: result.files.single.size,
    //     ));
    //   });
    // }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Theme.of(context).colorScheme.primary),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Theme.of(context).colorScheme.primary),
                title: const Text('Upload Document'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _fabAnimationController.dispose();
    _suggestionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Safiyah AI'),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
              );
            },
            tooltip: 'Chat History',
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () {
              context.read<ChatbotBloc>().add(StartNewChat());
              _refreshSuggestions();
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops! Something went wrong',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {
                            context.read<ChatbotBloc>().add(LoadChatHistory());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
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
                    final message = state.messages[index];
                    return ChatMessageBubble(
                      message: message,
                      onSuggestionTap: _handleSuggestedQuestion,
                      onNavigate: message.toolCall?.navigationRoute != null
                          ? () {
                              context.read<ChatbotBloc>().add(NavigateFromTool(
                                route: message.toolCall!.navigationRoute!,
                                parameters: message.toolCall!.result,
                              ));
                            }
                          : null,
                      onCopy: () => _handleCopyMessage(message),
                      onShare: () => _handleShareMessage(message),
                      onLike: () => _handleLikeMessage(message),
                      onDislike: () => _handleDislikeMessage(message),
                      onRegenerate: () => _handleRegenerateMessage(message),
                      onEdit: message.sender == Sender.user
                          ? () => _handleEditMessage(message)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          if (_pendingAttachments.isNotEmpty) _buildAttachmentPreview(),
          _buildChatInput(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ).createShader(bounds),
            child: Text(
              'What can I help with?',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ask anything or try one of these',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.casino),
                onPressed: _refreshSuggestions,
                tooltip: 'Refresh suggestions',
                color: theme.colorScheme.primary,
              ),
            ],
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
    required String query,
    required Animation<double> animation,
    required int index,
  }) {
    final theme = Theme.of(context);
    
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: Offset(0, 0.2 * (index + 1)),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _textController.text = query;
              _sendMessage();
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surfaceContainerHighest,
                                         theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                  ],
                ),
                                 border: Border.all(
                   color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                 ),
                boxShadow: [
                  BoxShadow(
                                         color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                                             color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarterPrompts(BuildContext context) {
    return AnimatedBuilder(
      animation: _suggestionAnimationController,
      builder: (context, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: _currentSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = _currentSuggestions[index];
            return _buildSuggestionChip(
              context,
              icon: suggestion['icon'],
              text: suggestion['text'],
              query: suggestion['query'],
              animation: _suggestionAnimationController,
              index: index,
            );
          },
        );
      },
    );
  }

  Widget _buildAttachmentPreview() {
    final theme = Theme.of(context);
    
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pendingAttachments.length,
        itemBuilder: (context, index) {
          final attachment = _pendingAttachments[index];
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: AttachmentPreview(
                  attachment: attachment,
                  isUser: true,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: theme.colorScheme.onError,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _pendingAttachments.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = _textController.text.trim().isNotEmpty;
    final hasAttachments = _pendingAttachments.isNotEmpty;
    final canSend = hasText || hasAttachments;
    
    return Material(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
                     border: Border(
             top: BorderSide(
               color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
             ),
           ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _pendingAttachments.isNotEmpty
                            ? Icons.add_circle
                            : Icons.add_circle_outline,
                        key: ValueKey(_pendingAttachments.isNotEmpty),
                        color: _pendingAttachments.isNotEmpty
                            ? theme.colorScheme.primary
                            : null,
                      ),
                    ),
                    onPressed: _showAttachmentOptions,
                    tooltip: 'Add attachment',
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (_) => canSend ? _sendMessage() : null,
                            decoration: InputDecoration(
                              hintText: 'Ask Safiyah anything...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 4,
                            minLines: 1,
                          ),
                        ),
                        if (!hasText)
                          IconButton(
                            icon: const Icon(Icons.mic_none_outlined),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Voice input coming soon!'),
                                ),
                              );
                            },
                            tooltip: 'Voice Input',
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        canSend
                            ? Icons.send_rounded
                            : Icons.auto_awesome,
                        key: ValueKey(canSend),
                        color: canSend
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onPressed: canSend ? _sendMessage : _navigateToRealtimeChat,
                    tooltip: canSend ? 'Send Message' : 'Start Smart AI Chat',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
