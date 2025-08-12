import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CommunityGroupType {
  nyumbaKumi,
  estate,
  neighborhood,
  building,
}

enum MessageType {
  text,
  image,
  document,
  announcement,
  poll,
}

class CommunityGroup {
  final String id;
  final String name;
  final String description;
  final CommunityGroupType type;
  final String? imageUrl;
  final DateTime createdAt;
  final List<String> memberIds;
  final List<String> adminIds;
  final String location;
  final bool isPrivate;
  final int messageCount;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.createdAt,
    required this.memberIds,
    required this.adminIds,
    required this.location,
    this.isPrivate = false,
    this.messageCount = 0,
  });

  CommunityGroup copyWith({
    String? id,
    String? name,
    String? description,
    CommunityGroupType? type,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? memberIds,
    List<String>? adminIds,
    String? location,
    bool? isPrivate,
    int? messageCount,
  }) {
    return CommunityGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      adminIds: adminIds ?? this.adminIds,
      location: location ?? this.location,
      isPrivate: isPrivate ?? this.isPrivate,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}

class CommunityMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String>? attachments;
  final Map<String, dynamic>? metadata;
  final bool isAnnouncement;
  final List<String> readBy;

  CommunityMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.attachments,
    this.metadata,
    this.isAnnouncement = false,
    this.readBy = const [],
  });

  CommunityMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
    bool? isAnnouncement,
    List<String>? readBy,
  }) {
    return CommunityMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      readBy: readBy ?? this.readBy,
    );
  }
}

class CommunityService extends ChangeNotifier {
  final List<CommunityGroup> _groups = [];
  final Map<String, List<CommunityMessage>> _groupMessages = {};
  final String _currentUserId = 'current_user_123'; // This would come from auth

  List<CommunityGroup> get groups => List.unmodifiable(_groups);
  String get currentUserId => _currentUserId;

  CommunityService() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample Nyumba Kumi groups
    final sampleGroups = [
      CommunityGroup(
        id: 'nk_westlands_001',
        name: 'Westlands Nyumba Kumi',
        description: 'Community safety and neighborhood watch for Westlands area',
        type: CommunityGroupType.nyumbaKumi,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        memberIds: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', _currentUserId],
        adminIds: ['user_1', _currentUserId],
        location: 'Westlands, Nairobi',
        messageCount: 15,
      ),
      CommunityGroup(
        id: 'estate_karen_001',
        name: 'Karen Estate Residents',
        description: 'Karen Estate community for residents and property owners',
        type: CommunityGroupType.estate,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        memberIds: ['user_6', 'user_7', 'user_8', _currentUserId],
        adminIds: ['user_6'],
        location: 'Karen, Nairobi',
        messageCount: 8,
      ),
      CommunityGroup(
        id: 'nk_kileleshwa_001',
        name: 'Kileleshwa Nyumba Kumi',
        description: 'Safety and security for Kileleshwa neighborhood',
        type: CommunityGroupType.nyumbaKumi,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        memberIds: ['user_9', 'user_10', 'user_11', _currentUserId],
        adminIds: ['user_9'],
        location: 'Kileleshwa, Nairobi',
        messageCount: 22,
      ),
      CommunityGroup(
        id: 'building_abc_001',
        name: 'ABC Towers Residents',
        description: 'Residents of ABC Towers building',
        type: CommunityGroupType.building,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        memberIds: ['user_12', 'user_13', _currentUserId],
        adminIds: ['user_12'],
        location: 'Kilimani, Nairobi',
        isPrivate: true,
        messageCount: 5,
      ),
    ];

    _groups.addAll(sampleGroups);

    // Sample messages for the first group
    _initializeSampleMessages();
  }

  void _initializeSampleMessages() {
    final westlandsGroupId = 'nk_westlands_001';
    final sampleMessages = [
      CommunityMessage(
        id: 'msg_001',
        groupId: westlandsGroupId,
        senderId: 'user_1',
        senderName: 'Samuel Wanjiku',
        content: 'Good evening everyone. Just wanted to remind you about our security meeting tomorrow at 6 PM at the community center.',
        type: MessageType.announcement,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isAnnouncement: true,
        readBy: [_currentUserId],
      ),
      CommunityMessage(
        id: 'msg_002',
        groupId: westlandsGroupId,
        senderId: 'user_2',
        senderName: 'Mary Njoki',
        content: 'Thank you for the reminder Samuel. Will there be any agenda shared beforehand?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        readBy: [_currentUserId],
      ),
      CommunityMessage(
        id: 'msg_003',
        groupId: westlandsGroupId,
        senderId: 'user_3',
        senderName: 'John Kimani',
        content: 'I spotted some suspicious activity near the shopping center yesterday evening. Two individuals on a motorbike were checking out parked cars.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        readBy: [_currentUserId],
      ),
      CommunityMessage(
        id: 'msg_004',
        groupId: westlandsGroupId,
        senderId: _currentUserId,
        senderName: 'You',
        content: 'Thanks for sharing John. Did you manage to get their number plate or any other details?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        readBy: ['user_1', 'user_2', 'user_3'],
      ),
      CommunityMessage(
        id: 'msg_005',
        groupId: westlandsGroupId,
        senderId: 'user_4',
        senderName: 'Grace Achieng',
        content: 'I\'ll be attending the meeting tomorrow. We also need to discuss the broken street light on Muthithi Road.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        readBy: [],
      ),
    ];

    _groupMessages[westlandsGroupId] = sampleMessages;
  }

  // Get groups by type
  List<CommunityGroup> getGroupsByType(CommunityGroupType type) {
    return _groups.where((group) => group.type == type).toList();
  }

  // Get user's groups
  List<CommunityGroup> getUserGroups() {
    return _groups.where((group) => group.memberIds.contains(_currentUserId)).toList();
  }

  // Get messages for a group
  List<CommunityMessage> getGroupMessages(String groupId) {
    return _groupMessages[groupId] ?? [];
  }

  // Send a message
  void sendMessage({
    required String groupId,
    required String content,
    MessageType type = MessageType.text,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
    bool isAnnouncement = false,
  }) {
    final message = CommunityMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      groupId: groupId,
      senderId: _currentUserId,
      senderName: 'You',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      attachments: attachments,
      metadata: metadata,
      isAnnouncement: isAnnouncement,
    );

    if (_groupMessages[groupId] == null) {
      _groupMessages[groupId] = [];
    }

    _groupMessages[groupId]!.add(message);

    // Update group message count
    final groupIndex = _groups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      _groups[groupIndex] = _groups[groupIndex].copyWith(
        messageCount: _groups[groupIndex].messageCount + 1,
      );
    }

    notifyListeners();
  }

  // Join a group
  void joinGroup(String groupId) {
    final groupIndex = _groups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1 && !_groups[groupIndex].memberIds.contains(_currentUserId)) {
      final updatedMembers = List<String>.from(_groups[groupIndex].memberIds);
      updatedMembers.add(_currentUserId);
      
      _groups[groupIndex] = _groups[groupIndex].copyWith(memberIds: updatedMembers);
      notifyListeners();
    }
  }

  // Leave a group
  void leaveGroup(String groupId) {
    final groupIndex = _groups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1 && _groups[groupIndex].memberIds.contains(_currentUserId)) {
      final updatedMembers = List<String>.from(_groups[groupIndex].memberIds);
      updatedMembers.remove(_currentUserId);
      
      _groups[groupIndex] = _groups[groupIndex].copyWith(memberIds: updatedMembers);
      notifyListeners();
    }
  }

  // Create a new group
  void createGroup({
    required String name,
    required String description,
    required CommunityGroupType type,
    required String location,
    bool isPrivate = false,
    String? imageUrl,
  }) {
    final group = CommunityGroup(
      id: 'group_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      type: type,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      memberIds: [_currentUserId],
      adminIds: [_currentUserId],
      location: location,
      isPrivate: isPrivate,
    );

    _groups.insert(0, group);
    notifyListeners();
  }

  // Mark messages as read
  void markMessagesAsRead(String groupId, List<String> messageIds) {
    final messages = _groupMessages[groupId];
    if (messages != null) {
      for (int i = 0; i < messages.length; i++) {
        if (messageIds.contains(messages[i].id) && 
            !messages[i].readBy.contains(_currentUserId)) {
          final updatedReadBy = List<String>.from(messages[i].readBy);
          updatedReadBy.add(_currentUserId);
          messages[i] = messages[i].copyWith(readBy: updatedReadBy);
        }
      }
      notifyListeners();
    }
  }

  // Get unread message count for a group
  int getUnreadMessageCount(String groupId) {
    final messages = _groupMessages[groupId] ?? [];
    return messages.where((msg) => 
      msg.senderId != _currentUserId && 
      !msg.readBy.contains(_currentUserId)
    ).length;
  }

  // Search groups
  List<CommunityGroup> searchGroups(String query) {
    if (query.isEmpty) return _groups;
    
    return _groups.where((group) =>
      group.name.toLowerCase().contains(query.toLowerCase()) ||
      group.description.toLowerCase().contains(query.toLowerCase()) ||
      group.location.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Get nearby groups (mock implementation)
  List<CommunityGroup> getNearbyGroups(String userLocation) {
    // In a real app, this would use geolocation and filtering
    return _groups.where((group) => 
      group.location.toLowerCase().contains(userLocation.toLowerCase())
    ).toList();
  }
}

// Providers
final communityServiceProvider = ChangeNotifierProvider<CommunityService>((ref) {
  return CommunityService();
});

final userGroupsProvider = Provider<List<CommunityGroup>>((ref) {
  return ref.watch(communityServiceProvider).getUserGroups();
});

final nyumbaKumiGroupsProvider = Provider<List<CommunityGroup>>((ref) {
  return ref.watch(communityServiceProvider).getGroupsByType(CommunityGroupType.nyumbaKumi);
});

final groupMessagesProvider = Provider.family<List<CommunityMessage>, String>((ref, groupId) {
  return ref.watch(communityServiceProvider).getGroupMessages(groupId);
});

final unreadMessageCountProvider = Provider.family<int, String>((ref, groupId) {
  return ref.watch(communityServiceProvider).getUnreadMessageCount(groupId);
});
