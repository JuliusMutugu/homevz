import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;
  String _selectedProperty = 'All Properties';
  bool _isGeneratingReport = false;

  final List<String> _properties = [
    'All Properties',
    'Westlands Apartment',
    'Karen Villa',
    'Kilimani Studio',
    'Lavington House',
    'South B Bedsitter',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Reports',
          ),
          IconButton(
            onPressed: _generateAndDownloadReport,
            icon: const Icon(Icons.download),
            tooltip: 'Download Report',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Financial', icon: Icon(Icons.analytics, size: 20)),
            Tab(text: 'Occupancy', icon: Icon(Icons.home, size: 20)),
            Tab(text: 'Maintenance', icon: Icon(Icons.build, size: 20)),
            Tab(text: 'Tenant', icon: Icon(Icons.people, size: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Stats Header
          _buildQuickStatsHeader(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFinancialReport(),
                _buildOccupancyReport(),
                _buildMaintenanceReport(),
                _buildTenantReport(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateAndDownloadReport,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon:
            _isGeneratingReport
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Icon(Icons.picture_as_pdf),
        label: Text(_isGeneratingReport ? 'Generating...' : 'Download PDF'),
      ),
    );
  }

  Widget _buildQuickStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryGreen.withOpacity(0.1), Colors.white],
        ),
      ),
      child: Column(
        children: [
          // Date Range Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.date_range, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  'Total Revenue',
                  'KES 2,450,000',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStatCard(
                  'Occupancy Rate',
                  '87%',
                  Icons.home,
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStatCard(
                  'Maintenance Cost',
                  'KES 125,000',
                  Icons.build,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Chart Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue Trend',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Revenue Chart Placeholder\n(Chart library integration needed)',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Financial Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFinancialSummaryRow(
                    'Total Rent Collected',
                    'KES 2,250,000',
                    Colors.green,
                  ),
                  _buildFinancialSummaryRow(
                    'Security Deposits',
                    'KES 200,000',
                    AppColors.primaryGreen,
                  ),
                  _buildFinancialSummaryRow(
                    'Maintenance Costs',
                    'KES -125,000',
                    Colors.red,
                  ),
                  _buildFinancialSummaryRow(
                    'Property Management Fees',
                    'KES -45,000',
                    Colors.red,
                  ),
                  const Divider(),
                  _buildFinancialSummaryRow(
                    'Net Income',
                    'KES 2,280,000',
                    Colors.green,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentStatusTile(
                    'Paid on Time',
                    '15 tenants',
                    Colors.green,
                  ),
                  _buildPaymentStatusTile(
                    'Late Payments',
                    '3 tenants',
                    Colors.orange,
                  ),
                  _buildPaymentStatusTile(
                    'Outstanding',
                    '2 tenants',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Occupancy Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Occupancy Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOccupancyStatCard(
                          'Total Units',
                          '20',
                          Icons.home_work,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOccupancyStatCard(
                          'Occupied',
                          '17',
                          Icons.home,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOccupancyStatCard(
                          'Vacant',
                          '3',
                          Icons.home_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Property-wise Occupancy
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property-wise Occupancy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPropertyOccupancyTile(
                    'Westlands Apartment',
                    '100%',
                    '4/4 units',
                  ),
                  _buildPropertyOccupancyTile(
                    'Karen Villa',
                    '100%',
                    '1/1 unit',
                  ),
                  _buildPropertyOccupancyTile(
                    'Kilimani Studio',
                    '75%',
                    '6/8 units',
                  ),
                  _buildPropertyOccupancyTile(
                    'Lavington House',
                    '100%',
                    '3/3 units',
                  ),
                  _buildPropertyOccupancyTile(
                    'South B Bedsitter',
                    '60%',
                    '3/5 units',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Maintenance Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maintenance Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMaintenanceStatCard(
                          'Total Requests',
                          '45',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMaintenanceStatCard(
                          'Completed',
                          '38',
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMaintenanceStatCard(
                          'Pending',
                          '7',
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Maintenance Requests
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Maintenance Requests',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMaintenanceRequestTile(
                    'Plumbing Issue',
                    'Westlands Apartment - Unit 2A',
                    'Completed',
                    'KES 8,500',
                    Colors.green,
                  ),
                  _buildMaintenanceRequestTile(
                    'Electrical Repair',
                    'Karen Villa',
                    'In Progress',
                    'KES 12,000',
                    Colors.orange,
                  ),
                  _buildMaintenanceRequestTile(
                    'Painting Work',
                    'Kilimani Studio - Unit 5B',
                    'Pending',
                    'KES 15,000',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tenant Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tenant Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTenantStatCard(
                          'Total Tenants',
                          '17',
                          Icons.people,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTenantStatCard(
                          'New This Month',
                          '2',
                          Icons.person_add,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTenantStatCard(
                          'Move-outs',
                          '1',
                          Icons.person_remove,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tenant Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tenant Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTenantDetailTile(
                    'John Kamau',
                    'Westlands Apartment - Unit 2A',
                    'KES 45,000/month',
                    'Lease ends: Dec 2025',
                  ),
                  _buildTenantDetailTile(
                    'Mary Wanjiku',
                    'Karen Villa',
                    'KES 85,000/month',
                    'Lease ends: Mar 2026',
                  ),
                  _buildTenantDetailTile(
                    'David Mwangi',
                    'Kilimani Studio - Unit 1A',
                    'KES 25,000/month',
                    'Lease ends: Jun 2025',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryRow(
    String label,
    String amount,
    Color color, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusTile(String status, String count, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.payment, color: color, size: 20),
      ),
      title: Text(status),
      trailing: Text(
        count,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOccupancyStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyOccupancyTile(
    String property,
    String percentage,
    String units,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
        child: Icon(Icons.home, color: AppColors.primaryGreen),
      ),
      title: Text(property),
      subtitle: Text(units),
      trailing: Text(
        percentage,
        style: TextStyle(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildMaintenanceStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(Icons.build, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceRequestTile(
    String issue,
    String property,
    String status,
    String cost,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.build, color: statusColor),
        title: Text(issue),
        subtitle: Text(property),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              cost,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantDetailTile(
    String name,
    String property,
    String rent,
    String lease,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
          child: Text(
            name[0],
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property),
            Text(
              lease,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: Text(
          rent,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Reports'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Range Picker
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Date Range'),
                  subtitle: Text(
                    '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                  ),
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: _selectedDateRange,
                    );
                    if (range != null) {
                      setState(() {
                        _selectedDateRange = range;
                      });
                    }
                  },
                ),

                // Property Selector
                DropdownButtonFormField<String>(
                  value: _selectedProperty,
                  decoration: const InputDecoration(
                    labelText: 'Property',
                    prefixIcon: Icon(Icons.home),
                  ),
                  items:
                      _properties.map((property) {
                        return DropdownMenuItem(
                          value: property,
                          child: Text(property),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProperty = value!;
                    });
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
                  setState(() {});
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
    );
  }

  void _generateAndDownloadReport() async {
    setState(() {
      _isGeneratingReport = true;
    });

    // Simulate PDF generation
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isGeneratingReport = false;
    });

    if (mounted) {
      _showDownloadSuccessDialog();
    }
  }

  void _showDownloadSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
            title: const Text('Report Generated!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Your report has been generated successfully.'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Property_Report_${_formatDate(DateTime.now())}.pdf',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Size: 2.4 MB',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report downloaded to Downloads folder'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Open File'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
