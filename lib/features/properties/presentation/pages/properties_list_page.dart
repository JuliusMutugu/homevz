import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/property_card.dart';
import '../../property_details_page.dart';

class PropertiesListPage extends ConsumerStatefulWidget {
  final String? initialSearchQuery;
  final String? initialLocation;

  const PropertiesListPage({
    super.key,
    this.initialSearchQuery,
    this.initialLocation,
  });

  @override
  ConsumerState<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends ConsumerState<PropertiesListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedLocation = 'All Locations';
  String _selectedPriceRange = 'All Prices';
  bool _showFilters = false;

  final List<String> _filterOptions = [
    'All',
    'Apartments',
    'Houses',
    'Bedsitters',
    'Land',
    'Commercial',
  ];

  final List<String> _locationOptions = [
    'All Locations',
    'Nairobi',
    'Westlands',
    'Kilimani',
    'Karen',
    'Kileleshwa',
    'South B',
    'South C',
    'Eastleigh',
    'Kasarani',
    'Embakasi',
  ];

  final List<String> _priceRangeOptions = [
    'All Prices',
    'Under 20K',
    '20K - 50K',
    '50K - 100K',
    '100K - 200K',
    'Above 200K',
  ];

  @override
  void initState() {
    super.initState();

    // Set initial search query if provided
    if (widget.initialSearchQuery != null) {
      _searchController.text = widget.initialSearchQuery!;
    }

    // Set initial location if provided
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            tooltip: 'Toggle Filters',
          ),
          IconButton(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search properties, locations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.grey100,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Filters Section
          if (_showFilters) _buildFiltersSection(),

          // Sort and Results Info
          _buildSortSection(),

          // Properties List
          Expanded(child: _buildPropertiesList()),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Property Type Filter
          _buildFilterRow(
            'Property Type',
            _selectedFilter,
            _filterOptions,
            (value) => setState(() => _selectedFilter = value),
          ),

          const SizedBox(height: 12),

          // Location Filter
          _buildFilterRow(
            'Location',
            _selectedLocation,
            _locationOptions,
            (value) => setState(() => _selectedLocation = value),
          ),

          const SizedBox(height: 12),

          // Price Range Filter
          _buildFilterRow(
            'Price Range',
            _selectedPriceRange,
            _priceRangeOptions,
            (value) => setState(() => _selectedPriceRange = value),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            items:
                options.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
            onChanged: (value) => onChanged(value!),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        children: [
          Text(
            '${_getFilteredProperties().length} properties found',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: 'Newest First',
            items:
                [
                  'Newest First',
                  'Price: Low to High',
                  'Price: High to Low',
                  'Most Popular',
                ].map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
            onChanged: (value) {
              // Handle sort change
            },
            underline: Container(),
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesList() {
    final properties = _getFilteredProperties();

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria or filters',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: PropertyCard(
              title: property['title'],
              location: property['location'],
              price: 'KES ${property['price']}',
              imageUrl: property['imageUrl'],
              propertyType: property['type'],
              bedrooms: property['bedrooms'],
              bathrooms: property['bathrooms'],
              isOccupied: false, // Default value
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PropertyDetailsPage(property: properties[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProperties() {
    List<Map<String, dynamic>> properties = _getSampleProperties();

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      properties =
          properties.where((property) {
            return property['title'].toString().toLowerCase().contains(query) ||
                property['location'].toString().toLowerCase().contains(query) ||
                property['description'].toString().toLowerCase().contains(
                  query,
                );
          }).toList();
    }

    // Filter by property type
    if (_selectedFilter != 'All') {
      properties =
          properties.where((property) {
            return property['type'].toString().toLowerCase() ==
                _selectedFilter.toLowerCase();
          }).toList();
    }

    // Filter by location
    if (_selectedLocation != 'All Locations') {
      properties =
          properties.where((property) {
            return property['location'].toString().contains(_selectedLocation);
          }).toList();
    }

    // Filter by price range
    if (_selectedPriceRange != 'All Prices') {
      properties =
          properties.where((property) {
            final price = property['price'] as int;
            switch (_selectedPriceRange) {
              case 'Under 20K':
                return price < 20000;
              case '20K - 50K':
                return price >= 20000 && price <= 50000;
              case '50K - 100K':
                return price >= 50000 && price <= 100000;
              case '100K - 200K':
                return price >= 100000 && price <= 200000;
              case 'Above 200K':
                return price > 200000;
              default:
                return true;
            }
          }).toList();
    }

    return properties;
  }

  List<Map<String, dynamic>> _getSampleProperties() {
    return [
      {
        'id': 1,
        'title': '2BR Apartment in Westlands',
        'location': 'Westlands, Nairobi',
        'price': 45000,
        'type': 'Apartments',
        'description': 'Modern apartment with great amenities',
        'bedrooms': 2,
        'bathrooms': 2,
        'area': '120 sqm',
        'imageUrl': 'assets/images/property1.jpg',
        'rating': 4.5,
        'featured': true,
      },
      {
        'id': 2,
        'title': 'Studio Apartment in Kilimani',
        'location': 'Kilimani, Nairobi',
        'price': 25000,
        'type': 'Apartments',
        'description': 'Cozy studio perfect for singles',
        'bedrooms': 1,
        'bathrooms': 1,
        'area': '45 sqm',
        'imageUrl': 'assets/images/property2.jpg',
        'rating': 4.2,
        'featured': false,
      },
      {
        'id': 3,
        'title': '3BR House in Karen',
        'location': 'Karen, Nairobi',
        'price': 80000,
        'type': 'Houses',
        'description': 'Spacious family house with garden',
        'bedrooms': 3,
        'bathrooms': 2,
        'area': '200 sqm',
        'imageUrl': 'assets/images/property3.jpg',
        'rating': 4.8,
        'featured': true,
      },
      {
        'id': 4,
        'title': 'Bedsitter in South B',
        'location': 'South B, Nairobi',
        'price': 18000,
        'type': 'Bedsitters',
        'description': 'Affordable bedsitter in quiet neighborhood',
        'bedrooms': 1,
        'bathrooms': 1,
        'area': '30 sqm',
        'imageUrl': 'assets/images/property4.jpg',
        'rating': 4.0,
        'featured': false,
      },
      {
        'id': 5,
        'title': '1BR Apartment in Kileleshwa',
        'location': 'Kileleshwa, Nairobi',
        'price': 35000,
        'type': 'Apartments',
        'description': 'Modern 1BR with all amenities',
        'bedrooms': 1,
        'bathrooms': 1,
        'area': '65 sqm',
        'imageUrl': 'assets/images/property5.jpg',
        'rating': 4.3,
        'featured': false,
      },
      {
        'id': 6,
        'title': 'Commercial Space in CBD',
        'location': 'CBD, Nairobi',
        'price': 120000,
        'type': 'Commercial',
        'description': 'Prime commercial space for business',
        'bedrooms': 0,
        'bathrooms': 2,
        'area': '150 sqm',
        'imageUrl': 'assets/images/property6.jpg',
        'rating': 4.6,
        'featured': true,
      },
    ];
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = 'All';
      _selectedLocation = 'All Locations';
      _selectedPriceRange = 'All Prices';
      _searchController.clear();
    });
  }
}
