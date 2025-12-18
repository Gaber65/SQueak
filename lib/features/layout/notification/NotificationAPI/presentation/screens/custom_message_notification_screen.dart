import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../domain/entities/notification_entities.dart';

class CustomMessageNotificationScreen extends StatelessWidget {
  final NotificationEntities notification;

  const CustomMessageNotificationScreen({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(S.of(context).customMessage),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Gradient
            _buildHeaderSection(),

            // Message Content Card
            _buildMessageCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Row(
        children: [
          // Notification Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getColorForType(notification.eventType),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _getColorForType(
                    notification.eventType,
                  ).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _getIconForType(notification.eventType),
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),

          // Title and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatFacebookTimePost(notification.createdAt),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message Label
          Row(
            children: [
              Icon(Icons.message, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'MESSAGE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Message Content
          Text(
            notification.message,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          // Event Type Badge
          if (notification.eventType != NotificationType.Unknown)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getColorForType(
                  notification.eventType,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForType(notification.eventType),
                    size: 16,
                    color: _getColorForType(notification.eventType),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    notification.eventType
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getColorForType(notification.eventType),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventTile(NotificationEventEntities event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            event.isRead ? Icons.check_circle : Icons.circle_outlined,
            color: event.isRead ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event ID: ${event.id}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${_getStatusText(event.notificationStatues)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(event.sendAt),
                style: const TextStyle(fontSize: 12),
              ),
              if (event.note.isNotEmpty)
                Text(
                  'Note: ${event.note}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.CustomeMessage:
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.CustomeMessage:
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Sent';
      case 2:
        return 'Delivered';
      case 3:
        return 'Read';
      default:
        return 'Unknown';
    }
  }
}
