import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_bloc.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_event.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_state.dart';
import 'dart:math' as math;

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  late AnimationController _searchAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _searchAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(LoadChatHistory());
    
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
    
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    
    _fabAnimationController.forward();
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
    
    if (_isSearching) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
      _searchController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching 
              ? _buildSearchField()
              : Text(
                  'Chat History',
                  key: const ValueKey('title'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: colorScheme.surfaceTint,
        actions: [
          IconButton(
            icon: AnimatedRotation(
              turns: _isSearching ? 0.25 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(_isSearching ? Icons.close : Icons.search),
            ),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Close Search' : 'Search History',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _showClearHistoryDialog(context);
                  break;
                case 'export':
                  _showExportDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined, size: 20, color: colorScheme.onSurface),
                    const SizedBox(width: 12),
                    const Text('Export History'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20, color: colorScheme.error),
                    const SizedBox(width: 12),
                    Text('Clear All', style: TextStyle(color: colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ChatbotBloc, ChatbotState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return _buildLoadingState();
          }
          
          if (state is ChatError) {
            return _buildErrorState(state.message);
          }

          // Group chat sessions by date and filter by search
          final chatSessions = _groupChatSessionsByDate(state.messages);
          final filteredSessions = _filterSessions(chatSessions);
          
          if (chatSessions.isEmpty) {
            return _buildEmptyState(context);
          }
          
          if (filteredSessions.isEmpty && _searchQuery.isNotEmpty) {
            return _buildNoSearchResults();
          }

          return _buildChatList(filteredSessions);
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.add_comment_outlined),
          label: const Text('New Chat'),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return TextField(
      key: const ValueKey('search'),
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search conversations...',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading chat history...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<ChatbotBloc>().add(LoadChatHistory());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or check your spelling',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(Map<String, List<ChatSession>> filteredSessions) {
    return CustomScrollView(
      slivers: [
        if (_searchQuery.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Found ${_getTotalSessionCount(filteredSessions)} conversation(s)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final dateGroup = filteredSessions.keys.elementAt(index);
              final sessions = filteredSessions[dateGroup]!;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0) const SizedBox(height: 8),
                  _buildDateHeader(context, dateGroup),
                  const SizedBox(height: 12),
                  ...sessions.map((session) => _buildChatSessionCard(context, session)),
                  const SizedBox(height: 24),
                ],
              );
            },
            childCount: filteredSessions.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100), // Space for FAB
        ),
      ],
    );
  }

  int _getTotalSessionCount(Map<String, List<ChatSession>> sessions) {
    return sessions.values.fold(0, (total, list) => total + list.length);
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Conversations Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start a conversation with Safiyah AI\nto see your chat history here',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.add_comment),
              label: const Text('Start Your First Chat'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        date,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildChatSessionCard(BuildContext context, ChatSession session) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => _loadChatSession(context, session),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: colorScheme.onPrimaryContainer,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                                      Row(
                              children: [
                                if (session.isPinned) ...[
                                  Icon(
                                    Icons.push_pin,
                                    size: 14,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Expanded(
                                  child: Text(
                                    session.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                session.time,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildActionButtons(context, session),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  session.preview,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 12,
                            color: colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.messageCount}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ChatSession session) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          onPressed: () => _showShareDialog(context, session),
          icon: Icon(Icons.share_outlined, size: 18),
          iconSize: 18,
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            padding: const EdgeInsets.all(8),
          ),
          tooltip: 'Share Chat',
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'delete':
                _showDeleteSessionDialog(context, session);
                break;
              case 'duplicate':
                _duplicateSession(context, session);
                break;
              case 'pin':
                _togglePinSession(context, session);
                break;
            }
          },
          icon: Icon(
            Icons.more_vert,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'pin',
              child: Row(
                children: [
                  Icon(
                    session.isPinned ? Icons.push_pin : Icons.push_pin_outlined, 
                    size: 18, 
                    color: session.isPinned ? colorScheme.primary : colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Text(session.isPinned ? 'Unpin Chat' : 'Pin Chat'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy_outlined, size: 18, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                  const Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
                  const SizedBox(width: 12),
                  Text('Delete', style: TextStyle(color: colorScheme.error)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, List<ChatSession>> _groupChatSessionsByDate(List<dynamic> messages) {
    // This is a mock implementation. In a real app, you'd group actual chat sessions
    final Map<String, List<ChatSession>> grouped = {};
    
    // Mock data for demonstration with more variety
    final mockSessions = [
      ChatSession(
        id: '1',
        title: 'Trip to Tokyo Planning',
        preview: 'Can you help me plan a 5-day itinerary for Tokyo with halal food options?',
        time: '10:30 AM',
        date: 'Today',
        messageCount: 12,
        isPinned: true,
      ),
      ChatSession(
        id: '2',
        title: 'Budget Calculation for Umrah',
        preview: 'I need help calculating the budget for my trip to Mecca and accommodation costs',
        time: '2:15 PM',
        date: 'Today',
        messageCount: 8,
        isPinned: false,
      ),
      ChatSession(
        id: '3',
        title: 'Kuala Lumpur Activities',
        preview: 'What are some halal-friendly activities in Kuala Lumpur for families?',
        time: '9:45 AM',
        date: 'Yesterday',
        messageCount: 15,
        isPinned: false,
      ),
      ChatSession(
        id: '4',
        title: 'Prayer Times Setup',
        preview: 'How do I set up prayer time notifications for my trip to different time zones?',
        time: '4:20 PM',
        date: 'Yesterday',
        messageCount: 6,
        isPinned: false,
      ),
      ChatSession(
        id: '5',
        title: 'Istanbul Restaurant Guide',
        preview: 'Best halal restaurants in Istanbul for Turkish cuisine and local specialties',
        time: '11:15 AM',
        date: 'December 20, 2024',
        messageCount: 20,
        isPinned: true,
      ),
      ChatSession(
        id: '6',
        title: 'Dubai Shopping Centers',
        preview: 'Shopping malls and traditional markets in Dubai with prayer facilities',
        time: '3:30 PM',
        date: 'December 20, 2024',
        messageCount: 9,
        isPinned: false,
      ),
    ];

    for (final session in mockSessions) {
      grouped.putIfAbsent(session.date, () => []).add(session);
    }
    
    // Sort sessions by pinned status and time
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.time.compareTo(a.time);
      });
    }

    return grouped;
  }

  void _loadChatSession(BuildContext context, ChatSession session) {
    // Load the selected chat session
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading chat: ${session.title}'),
      ),
    );
  }

  void _showDeleteSessionDialog(BuildContext context, ChatSession session) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Chat'),
          content: Text('Are you sure you want to delete "${session.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat deleted'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear All History'),
          content: const Text('Are you sure you want to delete all chat history? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All chat history cleared'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<ChatSession>> _filterSessions(Map<String, List<ChatSession>> sessions) {
    if (_searchQuery.isEmpty) return sessions;
    
    final Map<String, List<ChatSession>> filtered = {};
    
    for (final entry in sessions.entries) {
      final filteredSessions = entry.value.where((session) {
        return session.title.toLowerCase().contains(_searchQuery) ||
               session.preview.toLowerCase().contains(_searchQuery);
      }).toList();
      
      if (filteredSessions.isNotEmpty) {
        filtered[entry.key] = filteredSessions;
      }
    }
    
    return filtered;
  }

  void _showShareDialog(BuildContext context, ChatSession session) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share Conversation',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              session.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Generated Link Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Shareable Link',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'https://safiyah.app/chat/${session.id}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                    text: 'https://safiyah.app/chat/${session.id}',
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Link copied to clipboard!'),
                                      backgroundColor: colorScheme.primary,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy, size: 18),
                                tooltip: 'Copy Link',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Anyone with this link can view this conversation',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Share Options
                  Text(
                    'Share via',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Share Buttons Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildShareOption(
                        icon: Icons.message,
                        label: 'Messages',
                        color: colorScheme.primary,
                        onTap: () => _shareViaMessages(session),
                      ),
                      _buildShareOption(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        color: colorScheme.secondary,
                        onTap: () => _shareViaEmail(session),
                      ),
                      _buildShareOption(
                        icon: Icons.more_horiz,
                        label: 'More',
                        color: colorScheme.tertiary,
                        onTap: () => _shareViaOther(session),
                      ),
                      _buildShareOption(
                        icon: Icons.qr_code,
                        label: 'QR Code',
                        color: colorScheme.outline,
                        onTap: () => _showQRCode(session),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Privacy Note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.onTertiaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Shared conversations are read-only and expire after 30 days',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _shareViaMessages(ChatSession session) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Messages to share "${session.title}"'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _shareViaEmail(ChatSession session) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Email to share "${session.title}"'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _shareViaOther(ChatSession session) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening share menu for "${session.title}"'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _showQRCode(ChatSession session) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.qr_code, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text('QR Code'),
            ],
          ),
          content: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 120,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'QR Code would be\ngenerated here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _togglePinSession(BuildContext context, ChatSession session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          session.isPinned 
              ? '📌 "${session.title}" unpinned' 
              : '📌 "${session.title}" pinned',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateSession(BuildContext context, ChatSession session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ "${session.title}" duplicated'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.file_download_outlined, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Export Chat History'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose export format:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...['PDF Document', 'Text File', 'JSON Data'].map((format) => 
              ListTile(
                leading: Icon(
                  format == 'PDF Document' ? Icons.picture_as_pdf
                      : format == 'Text File' ? Icons.text_snippet
                      : Icons.code,
                  color: colorScheme.primary,
                ),
                title: Text(format),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Exporting as $format...'),
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class ChatSession {
  final String id;
  final String title;
  final String preview;
  final String time;
  final String date;
  final int messageCount;
  final bool isPinned;

  ChatSession({
    required this.id,
    required this.title,
    required this.preview,
    required this.time,
    required this.date,
    required this.messageCount,
    this.isPinned = false,
  });
} 