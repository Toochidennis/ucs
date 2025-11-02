import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/officer/controllers/officer_notifications_controller.dart';

class OfficerNotificationsView extends GetView<OfficerNotificationsController> {
  const OfficerNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Content
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final n = controller.notifications[index];
                  return _notificationCard(
                    title: n.title,
                    message: n.message,
                    time: n.time,
                    icon: n.icon,
                    color: n.color,
                    theme: theme,
                    isNew: n.isNew,
                    isOld: n.isOld,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Notification Card Widget
  Widget _notificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool isNew = false,
    bool isOld = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNew ? color.withOpacity(0.08) : theme.colorScheme.surface,
        border: Border.all(
          color: isNew ? color.withOpacity(0.3) : Colors.grey.shade300,
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
                  backgroundColor: color.withOpacity(0.15),
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
                          color: isNew
                              ? color // highlight with brand/accent color
                              : isOld
                              ? theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ) // faded
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Message
                      Text(
                        message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isNew
                              ? color
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Time
                      Text(
                        time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isNew
                              ? color.withOpacity(0.8)
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dot indicator for new notifications
          if (isNew)
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}
