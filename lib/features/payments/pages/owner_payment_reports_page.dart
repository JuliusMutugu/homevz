import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';

class OwnerPaymentReportsPage extends ConsumerStatefulWidget {
  const OwnerPaymentReportsPage({super.key});

  @override
  ConsumerState<OwnerPaymentReportsPage> createState() =>
      _OwnerPaymentReportsPageState();
}

class _OwnerPaymentReportsPageState
    extends ConsumerState<OwnerPaymentReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;
  String _selectedProperty = 'All Properties';
  String _selectedStatus = 'All Payments';

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
        title: const Text('Payment Reports'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Reports',
          ),
          IconButton(
            onPressed: () => _generateAndDownloadPDF(),
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF Report',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Recent Payments'),
            Tab(text: 'Monthly Report'),
            Tab(text: 'Property Breakdown'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildRecentPaymentsTab(),
          _buildMonthlyReportTab(),
          _buildPropertyBreakdownTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generateAndDownloadPDF(),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.download),
        label: const Text('Download PDF'),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Cards
          _buildStatsCards(),
          const SizedBox(height: 24),

          // Payment Trends Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Trends (Last 6 Months)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentTrendsChart(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Methods Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Methods Distribution',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentMethodsChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Collection',
          'KES 2,450,000',
          Icons.payments,
          Colors.green,
          '+12%',
        ),
        _buildStatCard(
          'This Month',
          'KES 350,000',
          Icons.calendar_today,
          AppColors.primaryGreen,
          '+8%',
        ),
        _buildStatCard(
          'Pending Payments',
          'KES 45,000',
          Icons.pending,
          Colors.orange,
          '3 tenants',
        ),
        _buildStatCard(
          'Overdue',
          'KES 12,000',
          Icons.warning,
          Colors.red,
          '1 tenant',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
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
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTrendsChart() {
    // Mock chart data - replace with actual chart implementation
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Payment Trends Chart'),
            Text(
              '(Integration with charts package needed)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsChart() {
    final methods = [
      {'name': 'M-Pesa', 'percentage': 65, 'color': Colors.green},
      {'name': 'Bank Transfer', 'percentage': 25, 'color': Colors.blue},
      {'name': 'Card Payment', 'percentage': 10, 'color': Colors.orange},
    ];

    return Column(
      children:
          methods.map((method) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: method['color'] as Color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(method['name'] as String)),
                  Text('${method['percentage']}%'),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildRecentPaymentsTab() {
    final payments = _getRecentPayments();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return _buildPaymentReportCard(payments[index]);
        },
      ),
    );
  }

  Widget _buildPaymentReportCard(Map<String, dynamic> payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                        payment['tenantName'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        payment['propertyTitle'],
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment['status']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    payment['status'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(payment['status']),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount: KES ${payment['amount']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      Text(
                        'Method: ${payment['method']}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        'Date: ${payment['date']}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _viewPaymentDetails(payment),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    if (payment['status'] == 'Paid')
                      TextButton.icon(
                        onPressed: () => _downloadPaymentReceipt(payment),
                        icon: const Icon(Icons.receipt, size: 16),
                        label: const Text('Receipt'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 8),
                  const Text('Select Month: '),
                  const Spacer(),
                  DropdownButton<String>(
                    value: 'November 2024',
                    items:
                        [
                          'November 2024',
                          'October 2024',
                          'September 2024',
                          'August 2024',
                        ].map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        // Update selected month
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Monthly Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'November 2024 Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Total Expected', 'KES 380,000'),
                  _buildSummaryRow('Total Collected', 'KES 350,000'),
                  _buildSummaryRow('Outstanding', 'KES 30,000'),
                  _buildSummaryRow('Collection Rate', '92.1%'),
                  const Divider(),
                  _buildSummaryRow('Properties', '12'),
                  _buildSummaryRow('Tenants Paid', '11/12'),
                  _buildSummaryRow('Late Payments', '2'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Property-wise breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property-wise Collection',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._getPropertyWiseData().map((property) {
                    return _buildPropertySummaryCard(property);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPropertySummaryCard(Map<String, dynamic> property) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${property['tenantsCount']} tenants',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'KES ${property['collected']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'of KES ${property['expected']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyBreakdownTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children:
            _getPropertyWiseData().map((property) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(property['name']),
                  subtitle: Text(
                    'Collection Rate: ${property['collectionRate']}%',
                    style: TextStyle(color: AppColors.primaryGreen),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Expected',
                            'KES ${property['expected']}',
                          ),
                          _buildSummaryRow(
                            'Collected',
                            'KES ${property['collected']}',
                          ),
                          _buildSummaryRow(
                            'Outstanding',
                            'KES ${property['outstanding']}',
                          ),
                          _buildSummaryRow(
                            'Tenants',
                            '${property['tenantsCount']}',
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _generatePropertyReport(property),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Download Property Report'),
                            style: ElevatedButton.styleFrom(
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
            }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getRecentPayments() {
    return [
      {
        'tenantName': 'John Kamau',
        'propertyTitle': '2BR Apartment - Westlands',
        'amount': '45,000',
        'method': 'M-Pesa',
        'date': '15 Nov 2024',
        'status': 'Paid',
        'transactionId': 'TXN2024001234',
        'rentPeriod': 'November 2024',
      },
      {
        'tenantName': 'Mary Wanjiku',
        'propertyTitle': 'Studio - Kilimani',
        'amount': '25,000',
        'method': 'Bank Transfer',
        'date': '14 Nov 2024',
        'status': 'Paid',
        'transactionId': 'TXN2024001235',
        'rentPeriod': 'November 2024',
      },
      {
        'tenantName': 'Peter Mutua',
        'propertyTitle': '3BR House - Karen',
        'amount': '80,000',
        'method': 'M-Pesa',
        'date': '10 Nov 2024',
        'status': 'Paid',
        'transactionId': 'TXN2024001236',
        'rentPeriod': 'November 2024',
      },
      {
        'tenantName': 'Grace Akinyi',
        'propertyTitle': '1BR Apartment - South B',
        'amount': '30,000',
        'method': 'Card Payment',
        'date': '05 Nov 2024',
        'status': 'Pending',
        'transactionId': 'TXN2024001237',
        'rentPeriod': 'November 2024',
      },
      {
        'tenantName': 'David Otieno',
        'propertyTitle': 'Bedsitter - Eastleigh',
        'amount': '18,000',
        'method': 'M-Pesa',
        'date': '01 Nov 2024',
        'status': 'Overdue',
        'transactionId': 'TXN2024001238',
        'rentPeriod': 'October 2024',
      },
    ];
  }

  List<Map<String, dynamic>> _getPropertyWiseData() {
    return [
      {
        'name': 'Westlands Apartments',
        'expected': '180,000',
        'collected': '180,000',
        'outstanding': '0',
        'tenantsCount': 4,
        'collectionRate': 100,
      },
      {
        'name': 'Kilimani Studios',
        'expected': '75,000',
        'collected': '50,000',
        'outstanding': '25,000',
        'tenantsCount': 3,
        'collectionRate': 67,
      },
      {
        'name': 'Karen Villas',
        'expected': '160,000',
        'collected': '160,000',
        'outstanding': '0',
        'tenantsCount': 2,
        'collectionRate': 100,
      },
      {
        'name': 'South B Apartments',
        'expected': '120,000',
        'collected': '90,000',
        'outstanding': '30,000',
        'tenantsCount': 4,
        'collectionRate': 75,
      },
    ];
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Payment Reports'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: const Text('Date Range'),
                    subtitle: Text(
                      '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: _selectedDateRange,
                      );
                      if (dateRange != null) {
                        setState(() {
                          _selectedDateRange = dateRange;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Property'),
                    subtitle: Text(_selectedProperty),
                    onTap: () {
                      Navigator.pop(context);
                      _showPropertySelector();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment),
                    title: const Text('Payment Status'),
                    subtitle: Text(_selectedStatus),
                    onTap: () {
                      Navigator.pop(context);
                      _showStatusSelector();
                    },
                  ),
                ],
              ),
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

  void _showPropertySelector() {
    final properties = [
      'All Properties',
      'Westlands Apartments',
      'Kilimani Studios',
      'Karen Villas',
      'South B Apartments',
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Property'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  properties.map((property) {
                    return ListTile(
                      title: Text(property),
                      onTap: () {
                        setState(() {
                          _selectedProperty = property;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showStatusSelector() {
    final statuses = ['All Payments', 'Paid', 'Pending', 'Overdue'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Payment Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  statuses.map((status) {
                    return ListTile(
                      title: Text(status),
                      onTap: () {
                        setState(() {
                          _selectedStatus = status;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  Future<void> _generateAndDownloadPDF() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generating PDF report...'),
          backgroundColor: Colors.blue,
        ),
      );

      // Simulate PDF generation delay
      await Future.delayed(const Duration(seconds: 2));

      // Create a simple text report instead of PDF for now
      final reportContent = '''
HomeVZ Payment Report
Generated: ${DateTime.now().toString().split('.')[0]}

=== PAYMENT SUMMARY ===
Total Collection: KES 2,450,000
This Month: KES 350,000
Pending Payments: KES 45,000
Overdue: KES 12,000

=== RECENT PAYMENTS ===
${_getRecentPayments().map((payment) => '''
${payment['tenantName']} - ${payment['propertyTitle']}
Amount: KES ${payment['amount']}
Method: ${payment['method']}
Date: ${payment['date']}
Status: ${payment['status']}
''').join('\n')}

=== PROPERTY BREAKDOWN ===
${_getPropertyWiseData().map((property) => '''
${property['name']}
Expected: KES ${property['expected']}
Collected: KES ${property['collected']}
Collection Rate: ${property['collectionRate']}%
''').join('\n')}
      ''';

      // For Android, try to save to Downloads directory
      try {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final fileName = 'payment_report_$timestamp.txt';
          final filePath = '${downloadsDir.path}/$fileName';

          final file = File(filePath);
          await file.writeAsString(reportContent);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Report saved to Downloads: $fileName'),
                backgroundColor: AppColors.primaryGreen,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(label: 'OK', onPressed: () {}),
              ),
            );
          }
        } else {
          throw Exception('Downloads directory not accessible');
        }
      } catch (e) {
        // Fallback: show the report content in a dialog
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Payment Report'),
                  content: SingleChildScrollView(
                    child: SelectableText(reportContent),
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
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePDF(String filePath) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File sharing not implemented yet'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _viewPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Payment Details - ${payment['tenantName']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Tenant', payment['tenantName']),
                  _buildDetailRow('Property', payment['propertyTitle']),
                  _buildDetailRow('Amount', 'KES ${payment['amount']}'),
                  _buildDetailRow('Method', payment['method']),
                  _buildDetailRow('Date', payment['date']),
                  _buildDetailRow('Status', payment['status']),
                  _buildDetailRow('Transaction ID', payment['transactionId']),
                  _buildDetailRow('Rent Period', payment['rentPeriod']),
                ],
              ),
            ),
            actions: [
              if (payment['status'] == 'Paid')
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _downloadPaymentReceipt(payment);
                  },
                  icon: const Icon(Icons.receipt),
                  label: const Text('Download Receipt'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
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
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _downloadPaymentReceipt(Map<String, dynamic> payment) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Generating receipt for ${payment['tenantName']}...'),
          backgroundColor: Colors.blue,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/data/data/com.example.homevz/files');
        }
      } else {
        downloadsDir = Directory('/storage/emulated/0/Download');
      }

      final fileName = 'receipt_${payment['transactionId']}.pdf';
      final filePath = '${downloadsDir.path}/$fileName';

      // Create a mock receipt PDF
      final file = File(filePath);
      await file.writeAsString('''
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj

4 0 obj
<<
/Length 150
>>
stream
BT
/F1 16 Tf
100 700 Td
(HomeVZ Payment Receipt) Tj
/F1 12 Tf
100 650 Td
(Tenant: ${payment['tenantName']}) Tj
100 630 Td
(Amount: KES ${payment['amount']}) Tj
100 610 Td
(Date: ${payment['date']}) Tj
100 590 Td
(Transaction ID: ${payment['transactionId']}) Tj
ET
endstream
endobj

xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000206 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
400
%%EOF
      ''');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receipt saved: $fileName'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'SHARE',
              onPressed: () => _sharePDF(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating receipt: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _generatePropertyReport(Map<String, dynamic> property) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating report for ${property['name']}...'),
        backgroundColor: Colors.blue,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    try {
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('/data/data/com.example.homevz/files');
        }
      } else {
        downloadsDir = Directory('/storage/emulated/0/Download');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          '${property['name'].toString().replaceAll(' ', '_')}_report_$timestamp.pdf';
      final filePath = '${downloadsDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString('''
%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj

2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj

3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj

4 0 obj
<<
/Length 200
>>
stream
BT
/F1 16 Tf
100 700 Td
(${property['name']} Payment Report) Tj
/F1 12 Tf
100 650 Td
(Expected: KES ${property['expected']}) Tj
100 630 Td
(Collected: KES ${property['collected']}) Tj
100 610 Td
(Outstanding: KES ${property['outstanding']}) Tj
100 590 Td
(Collection Rate: ${property['collectionRate']}%) Tj
100 570 Td
(Number of Tenants: ${property['tenantsCount']}) Tj
ET
endstream
endobj

xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000206 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
450
%%EOF
      ''');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property report saved: $fileName'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'SHARE',
              onPressed: () => _sharePDF(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating property report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
