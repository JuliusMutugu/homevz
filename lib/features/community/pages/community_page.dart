import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/services/community_service.dart';
import 'community_chat_page.dart';
import 'create_group_page.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            onPressed: () => _showCreateGroupDialog(),
            icon: const Icon(Icons.add),
            tooltip: 'Create Group',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Groups'),
            Tab(text: 'Nyumba Kumi'),
            Tab(text: 'Discover'),
            Tab(text: 'Nearby'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyGroupsTab(),
                _buildNyumbaKumiTab(),
                _buildDiscoverTab(),
                _buildNearbyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search groups...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(Icons.clear),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildMyGroupsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final userGroups = ref.watch(userGroupsProvider);
        final filteredGroups =
            _searchQuery.isEmpty
                ? userGroups
                : ref
                    .watch(communityServiceProvider)
                    .searchGroups(_searchQuery)
                    .where(
                      (group) => group.memberIds.contains(
                        ref.watch(communityServiceProvider).currentUserId,
                      ),
                    )
                    .toList();

        if (filteredGroups.isEmpty) {
          return _buildEmptyState(
            'No groups found',
            'Join some community groups to start connecting with your neighbors',
            Icons.people,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredGroups.length,
            itemBuilder: (context, index) {
              return _buildGroupCard(
                filteredGroups[index],
                showJoinButton: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNyumbaKumiTab() {
    return Consumer(
      builder: (context, ref, child) {
        final nyumbaKumiGroups = ref.watch(nyumbaKumiGroupsProvider);
        final filteredGroups =
            _searchQuery.isEmpty
                ? nyumbaKumiGroups
                : ref
                    .watch(communityServiceProvider)
                    .searchGroups(_searchQuery)
                    .where(
                      (group) => group.type == CommunityGroupType.nyumbaKumi,
                    )
                    .toList();

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nyumba Kumi Initiative',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Community-based security and neighborhood watch groups for safer communities.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  filteredGroups.isEmpty
                      ? _buildEmptyState(
                        'No Nyumba Kumi groups found',
                        'Be the first to create a Nyumba Kumi group in your area',
                        Icons.security,
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          return _buildGroupCard(filteredGroups[index]);
                        },
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDiscoverTab() {
    return Consumer(
      builder: (context, ref, child) {
        final allGroups = ref.watch(communityServiceProvider).groups;
        final currentUserId = ref.watch(communityServiceProvider).currentUserId;

        // Show groups the user hasn't joined yet
        final availableGroups =
            allGroups
                .where(
                  (group) =>
                      !group.memberIds.contains(currentUserId) &&
                      !group.isPrivate,
                )
                .toList();

        final filteredGroups =
            _searchQuery.isEmpty
                ? availableGroups
                : ref
                    .watch(communityServiceProvider)
                    .searchGroups(_searchQuery)
                    .where(
                      (group) =>
                          !group.memberIds.contains(currentUserId) &&
                          !group.isPrivate,
                    )
                    .toList();

        if (filteredGroups.isEmpty) {
          return _buildEmptyState(
            'No groups to discover',
            'All available groups have been joined or there are no public groups yet',
            Icons.explore,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredGroups.length,
          itemBuilder: (context, index) {
            return _buildGroupCard(filteredGroups[index], showJoinButton: true);
          },
        );
      },
    );
  }

  Widget _buildNearbyTab() {
    return Consumer(
      builder: (context, ref, child) {
        // Mock user location - in real app, get from GPS
        const userLocation = 'Westlands, Nairobi';
        final nearbyGroups = ref
            .watch(communityServiceProvider)
            .getNearbyGroups(userLocation);
        final currentUserId = ref.watch(communityServiceProvider).currentUserId;

        final filteredGroups =
            _searchQuery.isEmpty
                ? nearbyGroups
                : ref
                    .watch(communityServiceProvider)
                    .searchGroups(_searchQuery)
                    .where(
                      (group) =>
                          group.location.toLowerCase().contains('westlands'),
                    )
                    .toList();

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Location: $userLocation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Groups in your area for local community engagement.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  filteredGroups.isEmpty
                      ? _buildEmptyState(
                        'No nearby groups found',
                        'No community groups found in your area yet',
                        Icons.location_off,
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          final group = filteredGroups[index];
                          final isJoined = group.memberIds.contains(
                            currentUserId,
                          );
                          return _buildGroupCard(
                            group,
                            showJoinButton: !isJoined,
                          );
                        },
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupCard(CommunityGroup group, {bool showJoinButton = false}) {
    return Consumer(
      builder: (context, ref, child) {
        final unreadCount = ref.watch(unreadMessageCountProvider(group.id));
        final currentUserId = ref.watch(communityServiceProvider).currentUserId;
        final isAdmin = group.adminIds.contains(currentUserId);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              if (group.memberIds.contains(currentUserId)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityChatPage(group: group),
                  ),
                );
              } else if (showJoinButton) {
                _showJoinGroupDialog(group);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getGroupColor(group.type),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          _getGroupIcon(group.type),
                          color: Colors.white,
                          size: 24,
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
                                    group.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
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
                            ),
                            const SizedBox(height: 4),
                            Text(
                              group.location,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    group.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${group.memberIds.length} members',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.message, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${group.messageCount} messages',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const Spacer(),
                      if (showJoinButton)
                        ElevatedButton(
                          onPressed: () => _joinGroup(group),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(60, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text(
                            'Join',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getGroupColor(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return Colors.blue;
      case CommunityGroupType.estate:
        return Colors.green;
      case CommunityGroupType.neighborhood:
        return Colors.orange;
      case CommunityGroupType.building:
        return Colors.purple;
    }
  }

  IconData _getGroupIcon(CommunityGroupType type) {
    switch (type) {
      case CommunityGroupType.nyumbaKumi:
        return Icons.security;
      case CommunityGroupType.estate:
        return Icons.home_work;
      case CommunityGroupType.neighborhood:
        return Icons.location_city;
      case CommunityGroupType.building:
        return Icons.apartment;
    }
  }

  void _joinGroup(CommunityGroup group) {
    ref.read(communityServiceProvider).joinGroup(group.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Joined ${group.name}')));
  }

  void _showJoinGroupDialog(CommunityGroup group) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Join ${group.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.description),
                const SizedBox(height: 12),
                Text(
                  'Location: ${group.location}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'Members: ${group.memberIds.length}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _joinGroup(group);
                },
                child: const Text('Join'),
              ),
            ],
          ),
    );
  }

  void _showCreateGroupDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroupPage()),
    );
  }
}
