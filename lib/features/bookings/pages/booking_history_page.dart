import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class BookingHistoryPage extends ConsumerStatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  ConsumerState<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends ConsumerState<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

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
        title: const Text('Booking History'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Bookings',
          ),
          IconButton(
            onPressed: _exportBookings,
            icon: const Icon(Icons.download),
            tooltip: 'Export History',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
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
                hintText: 'Search bookings...',
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

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList('all'),
                _buildBookingsList('active'),
                _buildBookingsList('completed'),
                _buildBookingsList('cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String filter) {
    final bookings = _getFilteredBookings(filter);

    if (bookings.isEmpty) {
      return _buildEmptyState(filter);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index]);
        },
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'active':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = AppColors.grey500;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking['propertyTitle'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Property Details
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    booking['location'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Booked: ${booking['bookingDate']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Duration: ${booking['duration']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price and Actions Row
            Row(
              children: [
                Text(
                  'KES ${booking['amount']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (status.toLowerCase() == 'active') ...[
                  TextButton(
                    onPressed: () => _showCancelDialog(booking),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _viewBookingDetails(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View'),
                  ),
                ] else ...[
                  OutlinedButton(
                    onPressed: () => _viewBookingDetails(booking),
                    child: const Text('View Details'),
                  ),
                ],
              ],
            ),

            // Booking ID
            if (booking['bookingId'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Booking ID: ${booking['bookingId']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _copyBookingId(booking['bookingId']),
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    String title;
    String message;
    IconData icon;

    switch (filter) {
      case 'active':
        title = 'No Active Bookings';
        message = 'You don\'t have any active bookings at the moment';
        icon = Icons.event_available;
        break;
      case 'completed':
        title = 'No Completed Bookings';
        message = 'Your completed bookings will appear here';
        icon = Icons.task_alt;
        break;
      case 'cancelled':
        title = 'No Cancelled Bookings';
        message = 'No cancelled bookings found';
        icon = Icons.cancel;
        break;
      default:
        title = 'No Booking History';
        message = 'Start browsing properties to create your first booking';
        icon = Icons.history;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (filter == 'all') ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse Properties'),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredBookings(String filter) {
    final allBookings = _getSampleBookings();

    if (filter == 'all') return allBookings;

    return allBookings.where((booking) {
      return booking['status'].toString().toLowerCase() == filter;
    }).toList();
  }

  List<Map<String, dynamic>> _getSampleBookings() {
    return [
      {
        'bookingId': 'BK-2024-001',
        'propertyTitle': '2BR Apartment in Westlands',
        'location': 'Westlands, Nairobi',
        'bookingDate': '15 Nov 2024',
        'duration': '12 months',
        'amount': '45,000',
        'status': 'Active',
        'checkIn': '01 Dec 2024',
        'checkOut': '30 Nov 2025',
      },
      {
        'bookingId': 'BK-2024-002',
        'propertyTitle': 'Studio Apartment in Kilimani',
        'location': 'Kilimani, Nairobi',
        'bookingDate': '10 Oct 2024',
        'duration': '6 months',
        'amount': '25,000',
        'status': 'Completed',
        'checkIn': '01 Nov 2024',
        'checkOut': '30 Apr 2024',
      },
      {
        'bookingId': 'BK-2024-003',
        'propertyTitle': '4BR Villa in Karen',
        'location': 'Karen, Nairobi',
        'bookingDate': '20 Sep 2024',
        'duration': '24 months',
        'amount': '120,000',
        'status': 'Cancelled',
        'reason': 'Property not available',
      },
      {
        'bookingId': 'BK-2024-004',
        'propertyTitle': 'Bedsitter in South B',
        'location': 'South B, Nairobi',
        'bookingDate': '05 Nov 2024',
        'duration': '3 months',
        'amount': '18,000',
        'status': 'Pending',
        'checkIn': '01 Dec 2024',
        'checkOut': '28 Feb 2025',
      },
    ];
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Bookings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Date Range'),
                  subtitle: const Text('Filter by booking date'),
                  onTap: () async {
                    if (!mounted) return;
                    Navigator.pop(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final dateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (dateRange != null && mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Filtered from ${dateRange.start.toString().split(' ')[0]} to ${dateRange.end.toString().split(' ')[0]}',
                          ),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Location'),
                  subtitle: const Text('Filter by property location'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLocationFilter();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('Amount Range'),
                  subtitle: const Text('Filter by booking amount'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAmountFilter();
                  },
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

  void _showLocationFilter() {
    final locations = [
      'All Locations',
      'Westlands',
      'Kilimani',
      'Karen',
      'South B',
      'CBD',
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Location'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  locations.map((location) {
                    return ListTile(
                      title: Text(location),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filtered by: $location')),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showAmountFilter() {
    final ranges = [
      'All Amounts',
      'Under 20K',
      '20K - 50K',
      '50K - 100K',
      'Above 100K',
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Amount'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ranges.map((range) {
                    return ListTile(
                      title: Text(range),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filtered by: $range')),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _exportBookings() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Export Booking History'),
            content: const Text('Choose export format:'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting as PDF...')),
                  );
                },
                child: const Text('PDF'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting as CSV...')),
                  );
                },
                child: const Text('CSV'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _viewBookingDetails(Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsPage(booking: booking),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Booking'),
            content: Text(
              'Are you sure you want to cancel your booking for "${booking['propertyTitle']}"?\n\nCancellation may be subject to terms and conditions.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Booking'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancellation requested'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Cancel Booking'),
              ),
            ],
          ),
    );
  }

  void _copyBookingId(String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ID "$bookingId" copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Booking Details Page
class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading booking receipt...')),
              );
            },
            icon: const Icon(Icons.download),
            tooltip: 'Download Receipt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            booking['status'].toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Property Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Property', booking['propertyTitle']),
                    _buildDetailRow('Location', booking['location']),
                    _buildDetailRow('Booking ID', booking['bookingId']),
                    _buildDetailRow('Amount', 'KES ${booking['amount']}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Timeline Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Timeline',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Booking Date', booking['bookingDate']),
                    _buildDetailRow('Duration', booking['duration']),
                    if (booking['checkIn'] != null)
                      _buildDetailRow('Check-in', booking['checkIn']),
                    if (booking['checkOut'] != null)
                      _buildDetailRow('Check-out', booking['checkOut']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            if (booking['status'].toString().toLowerCase() == 'active') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacting landlord...')),
                    );
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Contact Landlord'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reporting issue...')),
                    );
                  },
                  icon: const Icon(Icons.report_problem),
                  label: const Text('Report Issue'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
  