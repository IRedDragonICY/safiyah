import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_bloc.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_event.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_state.dart';
import 'package:safiyah/presentation/widgets/chatbot/chat_context_menu.dart';
import 'package:safiyah/presentation/widgets/common/custom_text_field.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    final bool isUser = widget.message.sender == Sender.user;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceVariant;
    final textColor = isUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final bool isTyping = context.watch<ChatbotBloc>().state is ChatLoading && widget.message.text.isEmpty;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        GestureDetector(
          onTap: () {
            if (!isUser) {
              setState(() {
                _showActions = !_showActions;
              });
            }
          },
          onLongPressStart: (details) {
            _showContextMenu(context, details.globalPosition);
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
              ),
            ),
            child: isTyping
                ? const SizedBox(height: 24)
                : Text(
                    widget.message.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
          ),
        ),
        if (_showActions && !isUser) _buildBotActionRow(context),
      ],
    );
  }

  Widget _buildBotActionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(context, icon: Icons.copy_outlined, onTap: () {
              Clipboard.setData(ClipboardData(text: widget.message.text));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
          }),
          _buildActionButton(context, icon: Icons.thumb_up_alt_outlined, onTap: () {}),
          _buildActionButton(context, icon: Icons.thumb_down_alt_outlined, onTap: () {}),
          _buildActionButton(context, icon: Icons.volume_up_outlined, onTap: () {}),
          _buildActionButton(context, icon: Icons.refresh_outlined, onTap: () {
              context.read<ChatbotBloc>().add(RegenerateResponse(messageId: widget.message.id));
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onTap,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        splashRadius: 18,
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) async {
    final actions = widget.message.sender == Sender.user
        ? [ChatMenuAction.copy, ChatMenuAction.edit, ChatMenuAction.delete]
        : [ChatMenuAction.copy];

    final selectedAction = await showChatContextMenu(
      context: context,
      tapPosition: position,
      actions: actions,
    );

    if (selectedAction == null || !mounted) return;

    switch (selectedAction) {
      case ChatMenuAction.copy:
        Clipboard.setData(ClipboardData(text: widget.message.text));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
        break;
      case ChatMenuAction.edit:
        _showEditDialog(context, widget.message);
        break;
      case ChatMenuAction.delete:
        context.read<ChatbotBloc>().add(DeleteMessage(messageId: widget.message.id));
        break;
    }
  }

  void _showEditDialog(BuildContext context, ChatMessageModel message) {
    final TextEditingController editController = TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Message'),
        content: CustomTextField(
          controller: editController,
          maxLines: null,
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                context.read<ChatbotBloc>().add(EditMessage(
                      messageId: message.id,
                      newText: editController.text.trim(),
                    ));
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}