import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/student_notification_controller.dart';

class StudentNotificationView extends GetView<StudentNotificationController> {
  const StudentNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Header with Mark All Read button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.markAllAsRead,
                  child: Text(
                    "Mark all read",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.notifications.isEmpty) {
                return Center(
                  child: SpinKitChasingDots(
                    color: theme.colorScheme.primary,
                    size: 50,
                  ),
                );
              }

              if (controller.notifications.isEmpty) {
                return const Center(child: Text('No notifications yet'));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final n = controller.notifications[index];
                    return _notificationCard(
                      notificationId: n['id'],
                      title: n['title'],
                      message: n['message'],
                      time: n['time'],
                      icon: n['icon'],
                      color: n['color'],
                      theme: theme,
                      isNew: n['isNew'] ?? false,
                      isOld: n['isOld'] ?? false,
                      isRead: n['isRead'] ?? false,
                      officerName: n['officerName'],
                      unitName: n['unitName'],
                      onTap: () {
                        if (!n['isRead']) {
                          controller.markAsRead(n['id']);
                        }
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Notification Card Widget
  Widget _notificationCard({
    required String notificationId,
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool isNew = false,
    bool isOld = false,
    bool isRead = false,
    String? officerName,
    String? unitName,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead
              ? theme.colorScheme.surface.withValues(alpha: 0.5)
              : isNew
              ? color.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isRead
                ? Colors.grey.shade200
                : isNew
                ? color.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    radius: 20,
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isRead
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  )
                                : isNew
                                ? color
                                : isOld
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  )
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Message
                        Text(
                          message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isRead
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  )
                                : isNew
                                ? color
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Officer and Unit info if available
                        if (officerName != null || unitName != null)
                          Row(
                            children: [
                              if (officerName != null) ...[
                                Icon(
                                  Icons.person_outline,
                                  size: 12,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  officerName,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                              if (officerName != null && unitName != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    '•',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              if (unitName != null) ...[
                                Icon(
                                  Icons.business_outlined,
                                  size: 12,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  unitName,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        const SizedBox(height: 4),
                        // Time
                        Text(
                          time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: isRead
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  )
                                : isNew
                                ? color.withValues(alpha: 0.8)
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dot indicator for new/unread notifications
            if (!isRead)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
