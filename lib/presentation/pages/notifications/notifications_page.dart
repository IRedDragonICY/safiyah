import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/notification_model.dart';
import '../../bloc/notifications/notifications_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/notifications/notification_card.dart';
import '../../widgets/notifications/notification_filter_chips.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<NotificationsBloc>().add(const LoadNotifications());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBarFixed(context),
          _buildTabBarFixed(),
          Expanded(
            child: _buildContentFixed(),
          ),
        ],
      ),
    );
  }



  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    final groupedNotifications = _groupNotificationsByDate(notifications);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, index) {
        final group = groupedNotifications[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) const SizedBox(height: 4),
            _buildDateHeader(group['date'] as DateTime),
            const SizedBox(height: 8),
            ...((group['notifications'] as List<NotificationModel>)
                .map((notification) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NotificationCard(
                        notification: notification,
                        onTap: () => _handleNotificationTap(notification),
                        onDismiss: () => _handleNotificationDismiss(notification),
                      ),
                    ))),
            if (index == groupedNotifications.length - 1)
              const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 60,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you about important updates\nfor your travel plans',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    String dateText;
    if (difference == 0) {
      dateText = 'Today';
    } else if (difference == 1) {
      dateText = 'Yesterday';
    } else if (difference < 7) {
      dateText = DateFormat('EEEE').format(date);
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        dateText,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    final Map<String, List<NotificationModel>> grouped = {};

    for (final notification in notifications) {
      final dateKey = DateFormat('yyyy-MM-dd').format(notification.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(notification);
    }

    return grouped.entries
        .map((entry) => {
              'date': DateTime.parse(entry.key),
              'notifications': entry.value,
            })
        .toList()
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read if not already read
    if (!notification.isRead) {
      context.read<NotificationsBloc>().add(
            MarkNotificationAsRead(notification.id),
          );
    }

    // Navigate if deepLink exists
    if (notification.deepLink != null) {
      context.push(notification.deepLink!);
    }
  }

  void _handleNotificationDismiss(NotificationModel notification) {
    context.read<NotificationsBloc>().add(
          DeleteNotification(notification.id),
        );
  }

  Widget _buildAppBarFixed(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final unreadCount = state is NotificationsLoaded ? state.unreadCount : 0;
        
        return Container(
          height: 130 + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      if (unreadCount > 0)
                        TextButton.icon(
                          onPressed: () {
                            context.read<NotificationsBloc>().add(
                                  const MarkAllNotificationsAsRead(),
                                );
                          },
                          icon: const Icon(Icons.done_all, color: Colors.white, size: 20),
                          label: const Text(
                            'Mark all read',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Notifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '$unreadCount new',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stay updated with your travel plans',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBarFixed() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Unread'),
                ],
              ),
            ),
            const NotificationFilterChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentFixed() {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(child: LoadingWidget());
        }

        if (state is NotificationsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotificationsBloc>().add(
                          const LoadNotifications(),
                        );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is NotificationsLoaded) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildNotificationsList(state.filteredNotifications),
              _buildNotificationsList(
                state.filteredNotifications.where((n) => !n.isRead).toList(),
              ),
            ],
          );
        }

        return const Center(child: Text('No notifications'));
      },
    );
  }
}

