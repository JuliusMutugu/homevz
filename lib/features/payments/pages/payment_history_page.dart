import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../pages/payment_page.dart';

class PaymentHistoryPage extends ConsumerStatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  ConsumerState<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends ConsumerState<PaymentHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 90)),
      end: DateTime.now(),
    );
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
        title: const Text('Payment History'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Payments',
          ),
          IconButton(
            onPressed: _exportPayments,
            icon: const Icon(Icons.download),
            tooltip: 'Export History',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Payments'),
            Tab(text: 'Successful'),
            Tab(text: 'Pending'),
            Tab(text: 'Failed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),

          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search payments by property or transaction ID...',
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
                _buildPaymentsList('all'),
                _buildPaymentsList('successful'),
                _buildPaymentsList('pending'),
                _buildPaymentsList('failed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _makeNewPayment,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.payment),
        label: const Text('New Payment'),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryGreen.withOpacity(0.1), Colors.white],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Paid',
              'KES 1,350,000',
              Icons.payments,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'This Month',
              'KES 45,000',
              Icons.calendar_today,
              AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Pending',
              'KES 0',
              Icons.pending,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
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
              amount,
              style: TextStyle(
                fontSize: 14,
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

  Widget _buildPaymentsList(String filter) {
    final payments = _getFilteredPayments(filter);

    if (payments.isEmpty) {
      return _buildEmptyState(filter);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          return _buildPaymentCard(payments[index]);
        },
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    final status = payment['status'] as String;
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'successful':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['description'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
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
            const SizedBox(height: 12),

            // Payment Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            payment['date'],
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
                            _getPaymentMethodIcon(payment['method']),
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            payment['method'],
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KES ${payment['amount']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (payment['fee'] != null && payment['fee'] != '0')
                      Text(
                        'Fee: KES ${payment['fee']}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            // Transaction ID
            if (payment['transactionId'] != null) ...[
              const SizedBox(height: 12),
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
                      'Transaction ID: ${payment['transactionId']}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _copyTransactionId(payment['transactionId']),
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

            // Action Buttons
            const SizedBox(height: 12),
            Row(
              children: [
                if (status.toLowerCase() == 'failed') ...[
                  ElevatedButton.icon(
                    onPressed: () => _retryPayment(payment),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                OutlinedButton.icon(
                  onPressed: () => _viewPaymentDetails(payment),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
                const Spacer(),
                if (status.toLowerCase() == 'successful')
                  TextButton.icon(
                    onPressed: () => _downloadReceipt(payment),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Receipt'),
                  ),
              ],
            ),
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
      case 'successful':
        title = 'No Successful Payments';
        message = 'Your successful payments will appear here';
        icon = Icons.check_circle_outline;
        break;
      case 'pending':
        title = 'No Pending Payments';
        message = 'You don\'t have any pending payments';
        icon = Icons.pending_outlined;
        break;
      case 'failed':
        title = 'No Failed Payments';
        message = 'Great! You don\'t have any failed payments';
        icon = Icons.error_outline;
        break;
      default:
        title = 'No Payment History';
        message =
            'Your payment history will appear here once you make your first payment';
        icon = Icons.payment_outlined;
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
              onPressed: _makeNewPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Make a Payment'),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPayments(String filter) {
    final allPayments = _getSamplePayments();

    if (filter == 'all') return allPayments;

    return allPayments.where((payment) {
      return payment['status'].toString().toLowerCase() == filter;
    }).toList();
  }

  List<Map<String, dynamic>> _getSamplePayments() {
    return [
      {
        'transactionId': 'TXN2024001234',
        'description': 'Monthly Rent Payment',
        'propertyTitle': '2BR Apartment in Westlands',
        'amount': '45,000',
        'fee': '900',
        'date': '15 Nov 2024',
        'method': 'M-Pesa',
        'status': 'Successful',
        'type': 'Rent',
      },
      {
        'transactionId': 'TXN2024001235',
        'description': 'Security Deposit',
        'propertyTitle': 'Studio Apartment in Kilimani',
        'amount': '50,000',
        'fee': '1,000',
        'date': '10 Nov 2024',
        'method': 'Bank Transfer',
        'status': 'Successful',
        'type': 'Deposit',
      },
      {
        'transactionId': 'TXN2024001236',
        'description': 'Monthly Rent Payment',
        'propertyTitle': '2BR Apartment in Westlands',
        'amount': '45,000',
        'fee': '900',
        'date': '15 Oct 2024',
        'method': 'M-Pesa',
        'status': 'Successful',
        'type': 'Rent',
      },
      {
        'transactionId': 'TXN2024001237',
        'description': 'Maintenance Fee',
        'propertyTitle': '4BR Villa in Karen',
        'amount': '15,000',
        'fee': '300',
        'date': '08 Nov 2024',
        'method': 'Card Payment',
        'status': 'Failed',
        'type': 'Maintenance',
        'failureReason': 'Insufficient funds',
      },
      {
        'transactionId': 'TXN2024001238',
        'description': 'Monthly Rent Payment',
        'propertyTitle': 'Bedsitter in South B',
        'amount': '18,000',
        'fee': '360',
        'date': '01 Nov 2024',
        'method': 'M-Pesa',
        'status': 'Pending',
        'type': 'Rent',
      },
    ];
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'm-pesa':
        return Icons.phone_android;
      case 'bank transfer':
        return Icons.account_balance;
      case 'card payment':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Payments'),
            content: Column(
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
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment Method'),
                  subtitle: const Text('Filter by payment method'),
                  onTap: () {
                    Navigator.pop(context);
                    _showPaymentMethodFilter();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Payment Type'),
                  subtitle: const Text('Filter by payment type'),
                  onTap: () {
                    Navigator.pop(context);
                    _showPaymentTypeFilter();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('Amount Range'),
                  subtitle: const Text('Filter by payment amount'),
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

  void _showPaymentMethodFilter() {
    final methods = ['All Methods', 'M-Pesa', 'Bank Transfer', 'Card Payment'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Payment Method'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  methods.map((method) {
                    return ListTile(
                      leading: Icon(_getPaymentMethodIcon(method)),
                      title: Text(method),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filtered by: $method')),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showPaymentTypeFilter() {
    final types = ['All Types', 'Rent', 'Deposit', 'Maintenance', 'Utilities'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter by Payment Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  types.map((type) {
                    return ListTile(
                      title: Text(type),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Filtered by: $type')),
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
      'Under 10K',
      '10K - 30K',
      '30K - 50K',
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

  void _exportPayments() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Export Payment History'),
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

  void _makeNewPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const PaymentPage(
              propertyTitle: 'Sample Property',
              amount: 45000,
              paymentType: 'rent',
            ),
      ),
    );
  }

  void _viewPaymentDetails(Map<String, dynamic> payment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsPage(payment: payment),
      ),
    );
  }

  void _retryPayment(Map<String, dynamic> payment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentPage(
              propertyTitle: payment['propertyTitle'],
              amount: double.parse(payment['amount'].replaceAll(',', '')),
              paymentType: payment['type'].toLowerCase(),
            ),
      ),
    );
  }

  void _downloadReceipt(Map<String, dynamic> payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading receipt for ${payment['transactionId']}...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _copyTransactionId(String transactionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction ID "$transactionId" copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Payment Details Page
class PaymentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> payment;

  const PaymentDetailsPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading receipt...')),
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
            // Payment Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusContainer(payment['status']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Payment Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Amount', 'KES ${payment['amount']}'),
                    _buildDetailRow(
                      'Service Fee',
                      'KES ${payment['fee'] ?? '0'}',
                    ),
                    _buildDetailRow('Payment Method', payment['method']),
                    _buildDetailRow('Transaction ID', payment['transactionId']),
                    _buildDetailRow('Date', payment['date']),
                    _buildDetailRow('Type', payment['type']),
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
                      'Property Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Property', payment['propertyTitle']),
                    _buildDetailRow('Description', payment['description']),
                  ],
                ),
              ),
            ),

            if (payment['status'].toString().toLowerCase() == 'failed') ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Failure Information',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Reason',
                        payment['failureReason'] ?? 'Unknown error',
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            if (payment['status'].toString().toLowerCase() == 'successful') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading receipt...')),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Receipt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ] else if (payment['status'].toString().toLowerCase() ==
                'failed') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Retrying payment...')),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
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

  Widget _buildStatusContainer(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'successful':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
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
            width: 120,
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
            ),
          ),
        ],
      ),
    );
  }
}
