import 'package:flutter/material.dart';
import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/core/services/ai_tools_service.dart';
import 'package:safiyah/presentation/widgets/chatbot/attachment_preview.dart';
import 'package:safiyah/presentation/widgets/chatbot/tool_result_card.dart';
import 'package:safiyah/presentation/widgets/chatbot/suggested_questions_chips.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final Function(String)? onSuggestionTap;
  final VoidCallback? onNavigate;
  final VoidCallback? onCopy;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onRegenerate;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onSuggestionTap,
    this.onNavigate,
    this.onCopy,
    this.onLike,
    this.onDislike,
    this.onRegenerate,
    this.onShare,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isUser = message.sender == Sender.user;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 48 : 8,
        right: isUser ? 8 : 48,
        top: 4,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser && message.toolCall != null)
            _buildToolStatus(context),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) _buildAvatar(context),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.attachments.isNotEmpty)
                        _buildAttachments(context),
                      if (message.text.isNotEmpty || message.isTyping)
                        _buildMessageBubble(context, theme, isDarkMode, isUser),
                      if (message.toolCall != null &&
                          message.toolCall!.result != null)
                        _buildToolResult(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isUser && message.suggestedQuestions.isNotEmpty)
            _buildSuggestedQuestions(context),
          _buildActionButtons(context, isUser),
          if (message.timestamp != null) _buildTimestamp(context, isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          'S',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildToolStatus(BuildContext context) {
    final toolService = AIToolsService();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            toolService.getToolDescription(message.toolCall!.toolType),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.attachments.map((attachment) {
          return AttachmentPreview(
            attachment: attachment,
            isUser: message.sender == Sender.user,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ThemeData theme,
    bool isDarkMode,
    bool isUser,
  ) {
    return Material(
      color: isUser
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
        bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: message.isTyping
            ? _buildTypingIndicator(context, isUser)
            : SelectableText(
                message.text,
                style: TextStyle(
                  color: isUser
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context, bool isUser) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 600 + (index * 200)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isUser
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant)
                    .withValues(alpha: 0.3 + (0.7 * value)),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildToolResult(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: ToolResultCard(
        toolCall: message.toolCall!,
        onNavigate: onNavigate,
      ),
    );
  }

  Widget _buildSuggestedQuestions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 40),
      child: SuggestedQuestionsChips(
        questions: message.suggestedQuestions,
        onQuestionTap: onSuggestionTap,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isUser) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        left: isUser ? 0 : 40,
        right: isUser ? 0 : 40,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User-specific actions
          if (isUser) ...[
            // Edit button for user messages
            _buildActionButton(
              context,
              icon: Icons.edit_outlined,
              onTap: onEdit ?? () {},
              tooltip: 'Edit',
            ),
          ],
          
          // Copy button
          _buildActionButton(
            context,
            icon: Icons.copy_rounded,
            onTap: onCopy ?? () {},
            tooltip: 'Copy',
          ),
          
          // Share button
          _buildActionButton(
            context,
            icon: Icons.share_rounded,
            onTap: onShare ?? () {},
            tooltip: 'Share',
          ),
          
          // Bot-specific actions
          if (!isUser) ...[
            // Like button
            _buildActionButton(
              context,
              icon: Icons.thumb_up_outlined,
              onTap: onLike ?? () {},
              tooltip: 'Like',
            ),
            
            // Dislike button
            _buildActionButton(
              context,
              icon: Icons.thumb_down_outlined,
              onTap: onDislike ?? () {},
              tooltip: 'Dislike',
            ),
            
            // Regenerate button
            _buildActionButton(
              context,
              icon: Icons.refresh_rounded,
              onTap: onRegenerate ?? () {},
              tooltip: 'Regenerate',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context, bool isUser) {
    final time = message.timestamp!;
    final timeString =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        left: isUser ? 0 : 40,
        right: isUser ? 0 : 40,
      ),
      child: Text(
        timeString,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
      ),
    );
  }
}
