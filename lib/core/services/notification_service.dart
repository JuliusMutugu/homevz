import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationType {
  propertyUpdate,
  applicationUpdate,
  message,
  payment,
  maintenance,
  community,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      data: json['data'],
      imageUrl: json['imageUrl'],
      actionUrl: json['actionUrl'],
    );
  }
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _unreadCount;

  // Initialize with sample notifications for demo
  NotificationService() {
    _initializeSampleNotifications();
  }

  void _initializeSampleNotifications() {
    final sampleNotifications = [
      AppNotification(
        id: '1',
        title: 'New Property Application',
        body: 'Someone applied for your property in Westlands',
        type: NotificationType.applicationUpdate,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        data: {'propertyId': 'prop_001', 'applicantId': 'user_123'},
      ),
      AppNotification(
        id: '2',
        title: 'Payment Received',
        body: 'Rent payment of KES 50,000 received from John Doe',
        type: NotificationType.payment,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        data: {'amount': 50000, 'tenantId': 'user_456'},
      ),
      AppNotification(
        id: '3',
        title: 'Maintenance Request',
        body: 'New maintenance request for Apartment 2B',
        type: NotificationType.maintenance,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        data: {'propertyId': 'prop_002', 'requestId': 'maint_001'},
      ),
      AppNotification(
        id: '4',
        title: 'Community Update',
        body: 'New post in Westlands Nyumba Kumi group',
        type: NotificationType.community,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        data: {'groupId': 'nk_west_001', 'postId': 'post_123'},
      ),
      AppNotification(
        id: '5',
        title: 'Property Verified',
        body: 'Your property listing has been verified and is now live',
        type: NotificationType.propertyUpdate,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        data: {'propertyId': 'prop_003'},
      ),
    ];

    _notifications.addAll(sampleNotifications);
    _updateUnreadCount();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _updateUnreadCount();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _updateUnreadCount();
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _updateUnreadCount();
    notifyListeners();
  }

  List<AppNotification> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  // Simulate receiving new notifications
  void simulateNewNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.system,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      data: data,
    );
    
    addNotification(notification);
  }

  // Create specific notification types
  void createPropertyApplicationNotification({
    required String propertyTitle,
    required String applicantName,
    required String propertyId,
    required String applicantId,
  }) {
    simulateNewNotification(
      title: 'New Property Application',
      body: '$applicantName applied for $propertyTitle',
      type: NotificationType.applicationUpdate,
      data: {
        'propertyId': propertyId,
        'applicantId': applicantId,
        'propertyTitle': propertyTitle,
        'applicantName': applicantName,
      },
    );
  }

  void createPaymentNotification({
    required double amount,
    required String tenantName,
    required String propertyTitle,
  }) {
    simulateNewNotification(
      title: 'Payment Received',
      body: 'KES ${amount.toStringAsFixed(0)} received from $tenantName for $propertyTitle',
      type: NotificationType.payment,
      data: {
        'amount': amount,
        'tenantName': tenantName,
        'propertyTitle': propertyTitle,
      },
    );
  }

  void createMaintenanceNotification({
    required String propertyTitle,
    required String requestType,
    required String requestId,
  }) {
    simulateNewNotification(
      title: 'Maintenance Request',
      body: '$requestType request for $propertyTitle',
      type: NotificationType.maintenance,
      data: {
        'propertyTitle': propertyTitle,
        'requestType': requestType,
        'requestId': requestId,
      },
    );
  }

  void createCommunityNotification({
    required String groupName,
    required String message,
    required String groupId,
  }) {
    simulateNewNotification(
      title: 'Community Update',
      body: 'New message in $groupName: $message',
      type: NotificationType.community,
      data: {
        'groupName': groupName,
        'groupId': groupId,
        'message': message,
      },
    );
  }
}

// Provider for notification service
final notificationServiceProvider = ChangeNotifierProvider<NotificationService>((ref) {
  return NotificationService();
});

// Provider for notifications list
final notificationsProvider = Provider<List<AppNotification>>((ref) {
  return ref.watch(notificationServiceProvider).notifications;
});

// Provider for unread count
final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationServiceProvider).unreadCount;
});

// Provider for unread notifications
final unreadNotificationsProvider = Provider<List<AppNotification>>((ref) {
  return ref.watch(notificationServiceProvider).getUnreadNotifications();
});

// Provider for notifications by type
final notificationsByTypeProvider = Provider.family<List<AppNotification>, NotificationType>((ref, type) {
  return ref.watch(notificationServiceProvider).getNotificationsByType(type);
});
