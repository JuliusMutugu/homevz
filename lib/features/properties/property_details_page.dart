import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyDetailsPage({super.key, required this.property});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int currentImageIndex = 0;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(colorScheme),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyHeader(theme),
                _buildTabBar(colorScheme),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(theme),
                      _buildAmenitiesTab(theme),
                      _buildLocationTab(theme),
                      _buildReviewsTab(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(colorScheme),
    );
  }

  Widget _buildSliverAppBar(ColorScheme colorScheme) {
    final images =
        widget.property['images'] as List<String>? ??
        [
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800',
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ];

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: colorScheme.surface,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              }
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Property shared')));
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.home,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentImageIndex + 1}/${images.length}',
                  style: const TextStyle(
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
    );
  }

  Widget _buildPropertyHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.property['title'] ?? 'Beautiful Property',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.property['status'] ?? 'Available',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.property['location'] ?? 'Nairobi, Kenya',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'KES ${widget.property['price'] ?? '50,000'}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '/month',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _buildRating(theme),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPropertyFeature(
                Icons.bed,
                '${widget.property['bedrooms'] ?? 2} Beds',
                theme,
              ),
              const SizedBox(width: 24),
              _buildPropertyFeature(
                Icons.bathroom,
                '${widget.property['bathrooms'] ?? 2} Baths',
                theme,
              ),
              const SizedBox(width: 24),
              _buildPropertyFeature(
                Icons.square_foot,
                '${widget.property['area'] ?? 120} m²',
                theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFeature(IconData icon, String text, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRating(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.orange, size: 20),
        const SizedBox(width: 4),
        Text(
          '${widget.property['rating'] ?? 4.5}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ' (${widget.property['reviews'] ?? 24} reviews)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Amenities'),
          Tab(text: 'Location'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.property['description'] ??
                'This beautiful property offers modern living with excellent amenities. Located in a prime area of Nairobi, it provides easy access to shopping centers, schools, and public transport. The property features spacious rooms, modern fixtures, and a well-maintained compound with 24/7 security.',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 24),
          Text(
            'Property Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            'Property Type',
            widget.property['type'] ?? 'Apartment',
            theme,
          ),
          _buildDetailRow(
            'Furnishing',
            widget.property['furnishing'] ?? 'Semi-Furnished',
            theme,
          ),
          _buildDetailRow(
            'Floor',
            widget.property['floor'] ?? '2nd Floor',
            theme,
          ),
          _buildDetailRow(
            'Year Built',
            widget.property['yearBuilt'] ?? '2020',
            theme,
          ),
          _buildDetailRow(
            'Parking',
            widget.property['parking'] ?? '1 Space',
            theme,
          ),
          _buildDetailRow(
            'Pet Policy',
            widget.property['petPolicy'] ?? 'Pets Allowed',
            theme,
          ),
          const SizedBox(height: 24),
          Text(
            'Landlord Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildLandlordCard(theme),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandlordCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                'JM',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Mwangi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Property Owner',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (32 reviews)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling landlord...')),
                );
              },
              icon: Icon(Icons.phone, color: theme.colorScheme.primary),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sending message...')),
                );
              },
              icon: Icon(Icons.message, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesTab(ThemeData theme) {
    final amenities =
        widget.property['amenities'] as List<String>? ??
        [
          'WiFi',
          'Parking',
          'Security',
          'Water',
          'Electricity',
          'Gym',
          'Swimming Pool',
          'Elevator',
          'Garden',
          'CCTV',
        ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Amenities',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: amenities.length,
            itemBuilder: (context, index) {
              return _buildAmenityCard(amenities[index], theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCard(String amenity, ThemeData theme) {
    final iconMap = {
      'WiFi': Icons.wifi,
      'Parking': Icons.local_parking,
      'Security': Icons.security,
      'Water': Icons.water_drop,
      'Electricity': Icons.electrical_services,
      'Gym': Icons.fitness_center,
      'Swimming Pool': Icons.pool,
      'Elevator': Icons.elevator,
      'Garden': Icons.grass,
      'CCTV': Icons.videocam,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              iconMap[amenity] ?? Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                amenity,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-1.2921, 36.8219), // Nairobi coordinates
                  zoom: 15,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('property'),
                    position: LatLng(-1.2921, 36.8219),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                myLocationEnabled: false, // Disable to avoid permission errors
                myLocationButtonEnabled: false, // Disable location button
                compassEnabled: true,
                mapToolbarEnabled: false,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nearby Places',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildNearbyPlace(
            'Sarit Centre',
            '2.5 km',
            Icons.shopping_cart,
            theme,
          ),
          _buildNearbyPlace(
            'Westlands Primary School',
            '1.2 km',
            Icons.school,
            theme,
          ),
          _buildNearbyPlace(
            'Aga Khan Hospital',
            '3.1 km',
            Icons.local_hospital,
            theme,
          ),
          _buildNearbyPlace(
            'Westlands Matatu Stage',
            '800 m',
            Icons.directions_bus,
            theme,
          ),
          _buildNearbyPlace('KFC Westlands', '1.5 km', Icons.restaurant, theme),
        ],
      ),
    );
  }

  Widget _buildNearbyPlace(
    String name,
    String distance,
    IconData icon,
    ThemeData theme,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(name),
        trailing: Text(
          distance,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews & Ratings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRatingSummary(theme),
          const SizedBox(height: 24),
          Text(
            'Recent Reviews',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            'Sarah Wanjiku',
            4.5,
            'Great location and well-maintained property. The landlord is very responsive.',
            '2 weeks ago',
            theme,
          ),
          _buildReviewCard(
            'Michael Ochieng',
            5.0,
            'Excellent property with all promised amenities. Highly recommended!',
            '1 month ago',
            theme,
          ),
          _buildReviewCard(
            'Grace Muthoni',
            4.0,
            'Good value for money. The neighborhood is safe and quiet.',
            '2 months ago',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '4.5',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 20,
                    );
                  }),
                ),
                Text(
                  '24 reviews',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar('5 star', 0.6, theme),
                  _buildRatingBar('4 star', 0.3, theme),
                  _buildRatingBar('3 star', 0.1, theme),
                  _buildRatingBar('2 star', 0.0, theme),
                  _buildRatingBar('1 star', 0.0, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(String label, double value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    double rating,
    String review,
    String time,
    ThemeData theme,
  ) {
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
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    name[0],
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
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
                        name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Tour scheduled')));
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Schedule Tour'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                _showBookingBottomSheet(context);
              },
              icon: const Icon(Icons.home),
              label: const Text('Book Now'),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return _buildBookingSheet(context, scrollController);
            },
          ),
    );
  }

  Widget _buildBookingSheet(
    BuildContext context,
    ScrollController scrollController,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Book Property',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                _buildBookingForm(theme),
                const SizedBox(height: 24),
                _buildPricingBreakdown(theme),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Booking request submitted successfully!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Move-in Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Select move-in date',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 7)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Lease Duration',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(hintText: 'Select lease duration'),
          items:
              ['6 months', '1 year', '2 years']
                  .map(
                    (duration) => DropdownMenuItem(
                      value: duration,
                      child: Text(duration),
                    ),
                  )
                  .toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        Text(
          'Additional Notes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Any special requests or requirements...',
          ),
        ),
      ],
    );
  }

  Widget _buildPricingBreakdown(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPriceRow('Monthly Rent', 'KES 50,000', theme),
            _buildPriceRow('Security Deposit', 'KES 50,000', theme),
            _buildPriceRow('Agent Fee', 'KES 5,000', theme),
            const Divider(),
            _buildPriceRow(
              'Total Initial Payment',
              'KES 105,000',
              theme,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount,
    ThemeData theme, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isTotal ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
