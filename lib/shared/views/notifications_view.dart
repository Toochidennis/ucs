import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/shared/controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notifications", style: AppFont.titleSmall),
                TextButton(
                  onPressed: controller.markAllRead,
                  child: Text("Mark all read", style: AppFont.subtitle),
                ),
              ],
            ),
          ),

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
    bool isNew = false,
    bool isOld = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNew ? color.withOpacity(0.08) : const Color(AppColor.surface),
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
                        style: AppFont.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isNew
                              ? color // highlight with brand/accent color
                              : isOld
                              ? const Color(AppColor.onSurface).withOpacity(
                                  0.7,
                                ) // faded
                              : const Color(AppColor.onBackground),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Message
                      Text(
                        message,
                        style: AppFont.bodySmall.copyWith(
                          color: isNew
                              ? color
                              : const Color(
                                  AppColor.onSurface,
                                ).withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Time
                      Text(
                        time,
                        style: AppFont.caption.copyWith(
                          color: isNew
                              ? color.withOpacity(0.8)
                              : const Color(
                                  AppColor.onSurface,
                                ).withOpacity(0.6),
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
