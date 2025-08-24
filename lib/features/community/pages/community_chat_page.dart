import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/services/community_service.dart';
import '../../../core/services/image_upload_service.dart';

class CommunityChatPage extends ConsumerStatefulWidget {
  final CommunityGroup group;

  const CommunityChatPage({super.key, required this.group});

  @override
  ConsumerState<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends ConsumerState<CommunityChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(groupMessagesProvider(widget.group.id));
    final currentUserId = ref.watch(communityServiceProvider).currentUserId;
    final isAdmin = widget.group.adminIds.contains(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name, style: const TextStyle(fontSize: 16)),
            Text(
              '${widget.group.memberIds.length} members',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'group_info':
                  _showGroupInfo();
                  break;
                case 'leave_group':
                  _showLeaveGroupDialog();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'group_info',
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text('Group Info'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'leave_group',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Leave Group'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? _buildEmptyChat()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(
                          messages[index],
                          currentUserId,
                        );
                      },
                    ),
          ),
          _buildMessageInput(isAdmin),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to send a message!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(CommunityMessage message, String currentUserId) {
    final isOwnMessage = message.senderId == currentUserId;
    final isAnnouncement = message.isAnnouncement;

    if (isAnnouncement) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          border: Border.all(color: Colors.amber[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, color: Colors.amber[700], size: 16),
                const SizedBox(width: 4),
                Text(
                  'Announcement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              '${message.senderName} • ${timeago.format(message.timestamp)}',
              style: TextStyle(fontSize: 10, color: Colors.amber[600]),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child:
                  message.senderAvatar != null
                      ? ClipOval(
                        child: Image.network(
                          message.senderAvatar!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Text(
                        message.senderName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isOwnMessage
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isOwnMessage ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isOwnMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isOwnMessage ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                'Y',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _showAttachmentOptions,
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          if (isAdmin)
            IconButton(
              onPressed: _sendAnnouncement,
              icon: const Icon(Icons.campaign),
              tooltip: 'Send Announcement',
            ),
          IconButton(
            onPressed: _isLoading ? null : _sendMessage,
            icon:
                _isLoading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isLoading = true);

    ref
        .read(communityServiceProvider)
        .sendMessage(
          groupId: widget.group.id,
          content: content,
          type: MessageType.text,
        );

    _messageController.clear();
    setState(() => _isLoading = false);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendAnnouncement() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Send Announcement'),
            content: Text(
              'Send "$content" as an announcement to all group members?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(communityServiceProvider)
                      .sendMessage(
                        groupId: widget.group.id,
                        content: content,
                        type: MessageType.announcement,
                        isAnnouncement: true,
                      );
                  _messageController.clear();
                },
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendImage();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: const Text('Document'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendDocument();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickAndSendImage() async {
    final file = await ImageUploadService.pickImage();
    if (file != null) {
      // In a real app, upload the image and get URL
      ref
          .read(communityServiceProvider)
          .sendMessage(
            groupId: widget.group.id,
            content: 'Shared an image',
            type: MessageType.image,
            attachments: [file.path],
          );
    }
  }

  Future<void> _pickAndSendDocument() async {
    final files = await ImageUploadService.pickFiles(allowMultiple: false);
    if (files.isNotEmpty) {
      final file = files.first;
      final fileName = file.path.split('/').last;

      ref
          .read(communityServiceProvider)
          .sendMessage(
            groupId: widget.group.id,
            content: 'Shared document: $fileName',
            type: MessageType.document,
            attachments: [file.path],
          );
    }
  }

  void _showGroupInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(widget.group.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group.description),
                const SizedBox(height: 12),
                Text('Location: ${widget.group.location}'),
                Text('Members: ${widget.group.memberIds.length}'),
                Text('Created: ${timeago.format(widget.group.createdAt)}'),
                Text('Type: ${widget.group.type.name}'),
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

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Leave Group'),
            content: Text(
              'Are you sure you want to leave ${widget.group.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to community page
                  ref
                      .read(communityServiceProvider)
                      .leaveGroup(widget.group.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Left ${widget.group.name}')),
                  );
                },
                child: const Text('Leave'),
              ),
            ],
          ),
    );
  }
}
