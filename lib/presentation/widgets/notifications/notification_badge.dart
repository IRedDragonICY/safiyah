import 'package:flutter/material.dart';

import '../../../core/services/notification_service.dart';

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final Color badgeColor;
  final double size;

  const NotificationBadge({
    super.key,
    required this.child,
    this.badgeColor = Colors.red,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: NotificationService().notificationsStream,
      builder: (context, snapshot) {
        final unreadCount = NotificationService().unreadCount;
        
        return Stack(
          children: [
            child,
            if (unreadCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
} 