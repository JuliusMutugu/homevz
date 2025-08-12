import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/services/notification_service.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<NotificationType, String> _tabLabels = {
    NotificationType.applicationUpdate: 'Applications',
    NotificationType.payment: 'Payments',
    NotificationType.maintenance: 'Maintenance',
    NotificationType.community: 'Community',
    NotificationType.propertyUpdate: 'Properties',
    NotificationType.system: 'System',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabLabels.length + 1, // +1 for "All" tab
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = ref.watch(notificationServiceProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                notificationService.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All notifications marked as read')),
                );
              },
              child: const Text('Mark All Read'),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _showClearAllDialog();
                  break;
                case 'test_notification':
                  _createTestNotification();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test_notification',
                child: Row(
                  children: [
                    Icon(Icons.add_alert),
                    SizedBox(width: 8),
                    Text('Test Notification'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: 'All'),
            ..._tabLabels.values.map((label) => Tab(text: label)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotificationsTab(),
          ..._tabLabels.keys.map((type) => _buildNotificationsByType(type)),
        ],
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final notifications = ref.watch(notificationsProvider);
        
        if (notifications.isEmpty) {
          return _buildEmptyState('No notifications yet');
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationsByType(NotificationType type) {
    return Consumer(
      builder: (context, ref, child) {
        final notifications = ref.watch(notificationsByTypeProvider(type));
        
        if (notifications.isEmpty) {
          return _buildEmptyState('No ${_tabLabels[type]?.toLowerCase()} notifications');
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(notificationServiceProvider).deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              ref.read(notificationServiceProvider).markAsRead(notification.id);
            }
            _handleNotificationTap(notification);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead 
                                    ? FontWeight.normal 
                                    : FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeago.format(notification.timestamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
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
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.propertyUpdate:
        return Icons.home;
      case NotificationType.applicationUpdate:
        return Icons.assignment;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.maintenance:
        return Icons.build;
      case NotificationType.community:
        return Icons.people;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.propertyUpdate:
        return Colors.green;
      case NotificationType.applicationUpdate:
        return Colors.blue;
      case NotificationType.message:
        return Colors.purple;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.maintenance:
        return Colors.red;
      case NotificationType.community:
        return Colors.teal;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Handle navigation based on notification type and data
    switch (notification.type) {
      case NotificationType.propertyUpdate:
        // Navigate to property details
        break;
      case NotificationType.applicationUpdate:
        // Navigate to applications page
        break;
      case NotificationType.payment:
        // Navigate to payments page
        break;
      case NotificationType.maintenance:
        // Navigate to maintenance requests
        break;
      case NotificationType.community:
        // Navigate to community/chat
        break;
      default:
        // Show notification details
        _showNotificationDetails(notification);
        break;
    }
  }

  void _showNotificationDetails(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: 16),
            Text(
              'Received: ${timeago.format(notification.timestamp)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (notification.data != null) ...[
              const SizedBox(height: 16),
              const Text('Additional Info:'),
              const SizedBox(height: 8),
              ...notification.data!.entries.map(
                (entry) => Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(notificationServiceProvider).clearAllNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _createTestNotification() {
    final notificationService = ref.read(notificationServiceProvider);
    final testTypes = [
      () => notificationService.createPropertyApplicationNotification(
        propertyTitle: 'Modern 2BR Apartment in Westlands',
        applicantName: 'Jane Smith',
        propertyId: 'test_prop_001',
        applicantId: 'test_user_001',
      ),
      () => notificationService.createPaymentNotification(
        amount: 75000,
        tenantName: 'John Doe',
        propertyTitle: 'Executive Studio in Karen',
      ),
      () => notificationService.createMaintenanceNotification(
        propertyTitle: 'Luxury Villa in Lavington',
        requestType: 'Plumbing',
        requestId: 'maint_test_001',
      ),
      () => notificationService.createCommunityNotification(
        groupName: 'Westlands Nyumba Kumi',
        message: 'Security meeting scheduled for tomorrow',
        groupId: 'nk_west_001',
      ),
    ];

    // Create a random test notification
    final randomIndex = DateTime.now().millisecond % testTypes.length;
    testTypes[randomIndex]();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification created')),
    );
  }
}
