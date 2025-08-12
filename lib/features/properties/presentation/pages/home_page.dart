import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/models/user_role.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/widgets/image_picker_widget.dart';
import '../../../notifications/pages/notifications_page.dart';
import '../../../community/pages/community_page.dart';
import '../../../profile/pages/profile_page.dart';
import '../../property_details_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(userRoleProvider);
    final isOwner = userRole == UserRole.owner;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildNavigationDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: isOwner 
            ? [
                const _OwnerDashboardTab(),
                const _MyPropertiesTab(),
                const _ApplicationsTab(),
                const NotificationsPage(),
                const CommunityPage(),
                const ProfilePage(),
              ]
            : [
                const _HomeTab(),
                const _SearchTab(),
                const _FavoritesTab(),
                const NotificationsPage(),
                const CommunityPage(),
                const ProfilePage(),
              ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isOwner),
    );
  }

  Widget _buildBottomNavigationBar(bool isOwner) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.grey500,
      backgroundColor: AppColors.surface,
      elevation: 8,
      items: isOwner 
          ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_work_outlined),
                activeIcon: Icon(Icons.home_work),
                label: 'Properties',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                activeIcon: Icon(Icons.assignment),
                label: 'Applications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]
          : const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreen.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.surface,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'john.doe@email.com',
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  Icons.home,
                  'Home',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  Icons.person,
                  'My Profile',
                  () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 4; // Profile tab
                    });
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.favorite,
                  'My Favorites',
                  () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 2; // Favorites tab
                    });
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.message,
                  'Messages',
                  () {
                    Navigator.pop(context);
                    setState(() {
                      _currentIndex = 3; // Messages tab
                    });
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.history,
                  'Booking History',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking History opened')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.payment,
                  'Payment History',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment History opened')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.business,
                  'List Your Property',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Property listing form opened')),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  'Settings',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings opened')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.help,
                  'Help & Support',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support opened')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.info,
                  'About HomeVZ',
                  () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  'Logout',
                  () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
          
          // App Version
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? theme.colorScheme.error 
            : theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive 
              ? theme.colorScheme.error 
              : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.home,
              color: AppColors.primaryGreen,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('About HomeVZ'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Version: ${AppConstants.appVersion}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '© 2025 HomeVZ Kenya Ltd.',
              style: TextStyle(fontSize: 12),
            ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnPrimary,
          expandedHeight: 120,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Welcome to ${AppConstants.appName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.mpesaGreen,
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        
        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Quick actions
              _buildQuickActions(context),
              const SizedBox(height: 24),
              
              // Featured properties section
              _buildSectionHeader(context, 'Featured Properties', 'View All'),
              const SizedBox(height: 16),
              _buildFeaturedProperties(),
              const SizedBox(height: 24),
              
              // Categories section
              _buildSectionHeader(context, 'Browse by Category', ''),
              const SizedBox(height: 16),
              _buildCategories(),
              const SizedBox(height: 24),
              
              // Recent properties section
              _buildSectionHeader(context, 'Recent Listings', 'View All'),
              const SizedBox(height: 16),
              _buildRecentProperties(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Find Rental',
                    Icons.search,
                    AppColors.primaryGreen,
                    () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'List Property',
                    Icons.add_home,
                    AppColors.mpesaGreen,
                    () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Buy Land',
                    Icons.landscape,
                    AppColors.terracotta,
                    () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Get Loan',
                    Icons.account_balance,
                    AppColors.savanna,
                    () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (action.isNotEmpty)
          TextButton(
            onPressed: () {},
            child: Text(action),
          ),
      ],
    );
  }

  Widget _buildFeaturedProperties() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property image
                  Container(
                    height: 150,
                    color: AppColors.grey200,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2BR Apartment in Kilimani',
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nairobi, Kenya',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'KES 45,000/month',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'title': 'Apartments', 'icon': Icons.apartment, 'count': '1,234'},
      {'title': 'Houses', 'icon': Icons.house, 'count': '856'},
      {'title': 'Bedsitters', 'icon': Icons.single_bed, 'count': '2,341'},
      {'title': 'Land', 'icon': Icons.landscape, 'count': '567'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    category['icon'] as IconData,
                    color: AppColors.primaryGreen,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['title'] as String,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${category['count']} available',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentProperties() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image,
                color: AppColors.grey400,
              ),
            ),
            title: Text('3BR House in Westlands'),
            subtitle: Text('KES 80,000/month • Nairobi'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}

// Placeholder tabs
class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPropertyType = 'All';
  String _selectedLocation = 'All Locations';
  double _minPrice = 0;
  double _maxPrice = 100000;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Properties'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Column(
        children: [
          // Search bar and filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.grey50,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search properties, locations...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Implement search logic
                  },
                ),
                const SizedBox(height: 16),
                
                // Filters row
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterChip('Type', _selectedPropertyType, () {
                        _showPropertyTypeDialog();
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip('Location', _selectedLocation, () {
                        _showLocationDialog();
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip('Price', 'KES ${_minPrice.toInt()}k - ${_maxPrice.toInt()}k', () {
                        _showPriceDialog();
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Mock data
              itemBuilder: (context, index) {
                return _buildPropertyCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey300),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(int index) {
    final propertyData = {
      'title': '${index % 2 == 0 ? '2BR' : '3BR'} Apartment in ${AppConstants.popularAreas['Nairobi']![index % 4]}',
      'location': 'Nairobi, Kenya',
      'price': '${30000 + (index * 5000)}',
      'bedrooms': index % 2 == 0 ? 2 : 3,
      'bathrooms': index % 2 == 0 ? 2 : 3,
      'area': index % 2 == 0 ? 120 : 180,
      'type': 'Apartment',
      'rating': 4.5,
      'reviews': 24,
      'status': 'Available',
      'amenities': ['Parking', 'Security', 'Water', 'WiFi', 'Gym'],
      'images': [
        'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
      ],
    };

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(property: propertyData),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            Container(
              height: 200,
              width: double.infinity,
              color: AppColors.grey200,
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: AppColors.grey400,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surface.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    propertyData['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    propertyData['location'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KES ${propertyData['price']}/month',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Amenities
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildAmenityChip('Parking'),
                      _buildAmenityChip('Security'),
                      _buildAmenityChip('Water'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    return Chip(
      label: Text(
        amenity,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showPropertyTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Property Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All',
            ...AppConstants.propertyTypes,
          ].map((type) => RadioListTile<String>(
            title: Text(type),
            value: type,
            groupValue: _selectedPropertyType,
            onChanged: (value) {
              setState(() {
                _selectedPropertyType = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'All Locations',
            ...AppConstants.kenyanCounties.take(10), // Show top 10 counties
          ].map((location) => RadioListTile<String>(
            title: Text(location),
            value: location,
            groupValue: _selectedLocation,
            onChanged: (value) {
              setState(() {
                _selectedLocation = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPriceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Price Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('KES ${_minPrice.toInt()}k - ${_maxPrice.toInt()}k'),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 200000,
              divisions: 20,
              labels: RangeLabels(
                'KES ${_minPrice.toInt()}k',
                'KES ${_maxPrice.toInt()}k',
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _FavoritesTab extends StatefulWidget {
  const _FavoritesTab();

  @override
  State<_FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<_FavoritesTab> {
  List<int> favoriteProperties = [1, 3, 5, 7]; // Mock favorite IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              // Share favorites
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: favoriteProperties.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(favoriteProperties[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start browsing properties and save your favorites here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to search
            },
            child: const Text('Browse Properties'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(int propertyId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image with remove favorite button
          Container(
            height: 200,
            width: double.infinity,
            color: AppColors.grey200,
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: AppColors.grey400,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      _removeFavorite(propertyId);
                    },
                    icon: const Icon(Icons.favorite),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withOpacity(0.9),
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${propertyId % 2 == 0 ? '2BR' : '3BR'} Modern Apartment',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Remove'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'remove') {
                          _removeFavorite(propertyId);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Westlands, Nairobi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'KES ${(40000 + (propertyId * 3000))}/month',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Quick actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View details
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Contact landlord
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Contact'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(int propertyId) {
    setState(() {
      favoriteProperties.remove(propertyId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _MessagesTab extends StatefulWidget {
  const _MessagesTab();

  @override
  State<_MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<_MessagesTab> {
  final List<Message> messages = [
    Message(
      id: '1',
      senderName: 'John Kamau',
      senderType: 'Landlord',
      lastMessage: 'The apartment is still available. When can you view it?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      propertyTitle: '2BR Apartment in Kilimani',
    ),
    Message(
      id: '2',
      senderName: 'Mary Wanjiku',
      senderType: 'Property Agent',
      lastMessage: 'I have sent you the lease agreement for review.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      propertyTitle: '3BR House in Westlands',
    ),
    Message(
      id: '3',
      senderName: 'David Mwangi',
      senderType: 'Landlord',
      lastMessage: 'Thank you for your interest in the property.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      propertyTitle: 'Studio Apartment in CBD',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              // Search messages
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: messages.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageCard(messages[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Messages Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start browsing properties and connect with landlords',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Message message) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryGreen,
          child: Text(
            message.senderName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.senderName,
                style: TextStyle(
                  fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            Text(
              _formatTime(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderType,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: message.isRead ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Re: ${message.propertyTitle}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!message.isRead)
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(height: 4),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
            ),
          ],
        ),
        onTap: () {
          _openChat(message);
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _openChat(Message message) {
    // Mark as read
    setState(() {
      message.isRead = true;
    });

    // Navigate to chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(message: message),
      ),
    );
  }
}

class Message {
  final String id;
  final String senderName;
  final String senderType;
  final String lastMessage;
  final DateTime timestamp;
  bool isRead;
  final String propertyTitle;

  Message({
    required this.id,
    required this.senderName,
    required this.senderType,
    required this.lastMessage,
    required this.timestamp,
    required this.isRead,
    required this.propertyTitle,
  });
}

class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Load initial messages
    _messages.addAll([
      ChatMessage(
        text: widget.message.lastMessage,
        isMe: false,
        timestamp: widget.message.timestamp,
      ),
      ChatMessage(
        text: 'Hello! I\'m interested in viewing this property.',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message.senderName),
            Text(
              widget.message.propertyTitle,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              // Call landlord
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.primaryGreen : AppColors.grey200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

class _ProfileTab extends ConsumerStatefulWidget {
  const _ProfileTab();

  @override
  ConsumerState<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<_ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(userRoleProvider);
    final isOwner = userRole == UserRole.owner;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              // Edit profile
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.mpesaGreen,
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryWhite,
                    child: Text(
                      'JK',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Kamau',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.kamau@email.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryWhite.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+254 712 345 678',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryWhite.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // User role indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryWhite.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      isOwner ? 'Property Owner' : 'Tenant',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Favorites', '5', Icons.favorite),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Viewed', '12', Icons.visibility),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard('Inquiries', '3', Icons.message),
                  ),
                ],
              ),
            ),
            
            // Menu items
            _buildMenuSection([
              _buildMenuItem(
                'My Properties',
                'Manage your listed properties',
                Icons.home_work,
                () {},
              ),
              _buildMenuItem(
                'Payment History',
                'View your M-Pesa transactions',
                Icons.payment,
                () {},
              ),
              _buildMenuItem(
                'Saved Searches',
                'Access your saved search criteria',
                Icons.bookmark,
                () {},
              ),
              _buildMenuItem(
                'Notifications',
                'Manage notification preferences',
                Icons.notifications,
                () {},
              ),
            ]),
            
            const SizedBox(height: 16),
            
            _buildMenuSection([
              _buildMenuItem(
                'Switch to ${isOwner ? 'Tenant' : 'Owner'} Mode',
                isOwner 
                    ? 'Looking for a place to rent?' 
                    : 'Have properties to rent out?',
                isOwner ? Icons.search : Icons.home_work,
                () => _showRoleSwitchDialog(),
              ),
              _buildMenuItem(
                'Account Settings',
                'Update your account information',
                Icons.settings,
                () {},
              ),
              _buildMenuItem(
                'Privacy & Security',
                'Manage your privacy settings',
                Icons.security,
                () {},
              ),
              _buildMenuItem(
                'Help & Support',
                'Get help and contact support',
                Icons.help,
                () {},
              ),
              _buildMenuItem(
                'About HomeVZ',
                'App information and version',
                Icons.info,
                () {},
              ),
            ]),
            
            const SizedBox(height: 24),
            
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> items) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryGreen,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.grey400,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
              _handleLogout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // Implement logout logic
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/auth',
      (route) => false,
    );
  }

  void _showRoleSwitchDialog() {
    final userRole = ref.read(userRoleProvider);
    final isOwner = userRole == UserRole.owner;
    final newRole = isOwner ? UserRole.tenant : UserRole.owner;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Switch to ${newRole.title}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isOwner 
                  ? 'Switch to tenant mode to browse and rent properties.'
                  : 'Switch to owner mode to list and manage your properties.',
            ),
            const SizedBox(height: 12),
            Text(
              'Your current data will be preserved and you can switch back anytime.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(userProvider.notifier).setUserRole(newRole);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Switched to ${newRole.title} mode successfully!',
                      ),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                  // Reset to first tab
                  setState(() {
                    widget.key; // Trigger rebuild
                  });
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error switching roles: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }
}

// Owner-specific tabs
class _OwnerDashboardTab extends StatefulWidget {
  const _OwnerDashboardTab();

  @override
  State<_OwnerDashboardTab> createState() => _OwnerDashboardTabState();
}

class _OwnerDashboardTabState extends State<_OwnerDashboardTab> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your properties and tenants',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Properties',
                    '12',
                    Icons.home_work,
                    AppColors.primaryGreen,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Occupied',
                    '10',
                    Icons.people,
                    Colors.blue,
                    theme,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Monthly Revenue',
                    'KES 850K',
                    Icons.trending_up,
                    Colors.green,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending Apps',
                    '5',
                    Icons.assignment,
                    Colors.orange,
                    theme,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Add Property',
                    Icons.add_home,
                    AppColors.primaryGreen,
                    () {
                      _showAddPropertyDialog(context);
                    },
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Upload Photos',
                    Icons.photo_camera,
                    Colors.orange,
                    () {
                      _showPhotoUploadDialog(context);
                    },
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'View Reports',
                    Icons.analytics,
                    Colors.blue,
                    () {},
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    'Notifications',
                    Icons.notifications,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    theme,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activities
            Text(
              'Recent Activities',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildActivityCard(
              'New application for Westlands Apartment',
              'Sarah Wanjiku applied for 2BR apartment',
              '2 hours ago',
              Icons.assignment,
              theme,
            ),
            _buildActivityCard(
              'Rent payment received',
              'John Doe paid KES 45,000 for November',
              '1 day ago',
              Icons.payment,
              theme,
            ),
            _buildActivityCard(
              'Maintenance request',
              'Kitchen sink issue reported at Karen Villa',
              '2 days ago',
              Icons.build,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPropertyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Property'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Property Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Rent Amount (KES)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property added successfully!')),
              );
            },
            child: const Text('Add Property'),
          ),
        ],
      ),
    );
  }

  void _showPhotoUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Property Photos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select property photos to upload:'),
            const SizedBox(height: 16),
            ImagePickerWidget(
              maxImages: 5,
              title: 'Property Photos',
              subtitle: 'Add up to 5 photos of your property',
              onImagesChanged: (images) {
                // Handle image selection
                print('Selected ${images.length} images');
              },
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photos uploaded successfully!')),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String subtitle,
    String time,
    IconData icon,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primaryGreen),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MyPropertiesTab extends StatelessWidget {
  const _MyPropertiesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Properties',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Property feature coming soon')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Property'),
                ),
              ],
            ),
          ),
          
          // Properties List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPropertyCard(index, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(int index, ThemeData theme) {
    final properties = [
      {'name': 'Westlands Apartment', 'location': 'Westlands, Nairobi', 'rent': '45,000', 'status': 'Occupied'},
      {'name': 'Karen Villa', 'location': 'Karen, Nairobi', 'rent': '85,000', 'status': 'Occupied'},
      {'name': 'Kilimani Studio', 'location': 'Kilimani, Nairobi', 'rent': '25,000', 'status': 'Vacant'},
      {'name': 'Lavington House', 'location': 'Lavington, Nairobi', 'rent': '120,000', 'status': 'Occupied'},
      {'name': 'South B Bedsitter', 'location': 'South B, Nairobi', 'rent': '18,000', 'status': 'Vacant'},
    ];
    
    final property = properties[index];
    final isOccupied = property['status'] == 'Occupied';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property['name']!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property['location']!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOccupied 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    property['status']!,
                    style: TextStyle(
                      color: isOccupied ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Text(
                  'KES ${property['rent']}/month',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Rental Applications',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: const Text('5 Pending'),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
          
          // Applications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildApplicationCard(index, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(int index, ThemeData theme) {
    final applications = [
      {'name': 'Sarah Wanjiku', 'property': 'Westlands Apartment', 'date': '2 hours ago', 'status': 'Pending'},
      {'name': 'Michael Ochieng', 'property': 'Karen Villa', 'date': '1 day ago', 'status': 'Approved'},
      {'name': 'Grace Muthoni', 'property': 'Kilimani Studio', 'date': '2 days ago', 'status': 'Pending'},
      {'name': 'David Kimani', 'property': 'Lavington House', 'date': '3 days ago', 'status': 'Rejected'},
      {'name': 'Jane Achieng', 'property': 'South B Bedsitter', 'date': '1 week ago', 'status': 'Pending'},
    ];
    
    final application = applications[index];
    final status = application['status']!;
    Color statusColor;
    
    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  child: Text(
                    application['name']![0],
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application['name']!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Applied for ${application['property']}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Text(
                  application['date']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (status == 'Pending') ...[
                  TextButton(
                    onPressed: () {},
                    child: const Text('Reject'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Approve'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () {},
                    child: const Text('View Details'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
