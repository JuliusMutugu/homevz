import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final String propertyTitle;
  final double amount;
  final String paymentType; // 'rent', 'deposit', 'maintenance'

  const PaymentPage({
    super.key,
    required this.propertyTitle,
    required this.amount,
    required this.paymentType,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String _selectedPaymentMethod = 'mpesa';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  String _selectedBank = 'KCB Bank';
  bool _isProcessing = false;

  final List<String> _banks = [
    'KCB Bank',
    'Equity Bank',
    'Co-operative Bank',
    'NCBA Bank',
    'Absa Bank',
    'Standard Chartered',
    'Stanbic Bank',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary Card
            _buildPaymentSummary(),
            const SizedBox(height: 24),

            // Payment Method Selection
            _buildPaymentMethodSelection(),
            const SizedBox(height: 24),

            // Payment Details based on selected method
            _buildPaymentDetails(),
            const SizedBox(height: 32),

            // Process Payment Button
            _buildProcessPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Property', widget.propertyTitle),
            _buildSummaryRow('Payment Type', _getPaymentTypeDisplay()),
            _buildSummaryRow('Amount', 'KES ${_formatAmount(widget.amount)}'),
            if (widget.paymentType == 'rent') ...[
              const Divider(),
              _buildSummaryRow(
                'Service Fee',
                'KES ${_formatAmount(widget.amount * 0.02)}',
              ),
              _buildSummaryRow(
                'Total Amount',
                'KES ${_formatAmount(widget.amount + (widget.amount * 0.02))}',
                isTotal: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primaryGreen : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // M-Pesa Option
            _buildPaymentMethodTile(
              'mpesa',
              'M-Pesa',
              'Pay with your M-Pesa mobile money',
              Icons.phone_android,
              AppColors.mpesaGreen,
            ),

            // Bank Transfer Option
            _buildPaymentMethodTile(
              'bank',
              'Bank Transfer',
              'Transfer from your bank account',
              Icons.account_balance,
              AppColors.primaryGreen,
            ),

            // Card Payment Option
            _buildPaymentMethodTile(
              'card',
              'Debit/Credit Card',
              'Pay with your card',
              Icons.credit_card,
              AppColors.terracotta,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value!;
        });
      },
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
      activeColor: AppColors.primaryGreen,
    );
  }

  Widget _buildPaymentDetails() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return _buildMpesaDetails();
      case 'bank':
        return _buildBankDetails();
      case 'card':
        return _buildCardDetails();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMpesaDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'M-Pesa Payment Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'M-Pesa Phone Number',
                hintText: 'e.g., 0712345678',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mpesaGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.mpesaGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.mpesaGreen),
                      const SizedBox(width: 8),
                      const Text(
                        'How it works:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Enter your M-Pesa registered phone number'),
                  const Text('2. Click "Process Payment"'),
                  const Text('3. You\'ll receive an STK push on your phone'),
                  const Text('4. Enter your M-Pesa PIN to complete payment'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Transfer Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: const InputDecoration(
                labelText: 'Select Bank',
                prefixIcon: Icon(Icons.account_balance),
                border: OutlineInputBorder(),
              ),
              items:
                  _banks.map((bank) {
                    return DropdownMenuItem(value: bank, child: Text(bank));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bankAccountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Account Number',
                hintText: 'Enter your account number',
                prefixIcon: Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Payment Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessPaymentButton() {
    final totalAmount =
        widget.paymentType == 'rent'
            ? widget.amount + (widget.amount * 0.02)
            : widget.amount;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isProcessing
                ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Processing...'),
                  ],
                )
                : Text(
                  'Pay KES ${_formatAmount(totalAmount)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  String _getPaymentTypeDisplay() {
    switch (widget.paymentType) {
      case 'rent':
        return 'Monthly Rent';
      case 'deposit':
        return 'Security Deposit';
      case 'maintenance':
        return 'Maintenance Fee';
      default:
        return 'Payment';
    }
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  void _processPayment() async {
    if (!_validatePaymentDetails()) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      _showPaymentSuccessDialog();
    }
  }

  bool _validatePaymentDetails() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        if (_phoneController.text.isEmpty) {
          _showErrorSnackBar('Please enter your M-Pesa phone number');
          return false;
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(_phoneController.text)) {
          _showErrorSnackBar('Please enter a valid phone number');
          return false;
        }
        break;
      case 'bank':
        if (_bankAccountController.text.isEmpty) {
          _showErrorSnackBar('Please enter your account number');
          return false;
        }
        break;
      case 'card':
        // Add card validation logic here
        break;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
            title: const Text('Payment Successful!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your payment of KES ${_formatAmount(widget.amount)} has been processed successfully.',
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Transaction ID: TXN${DateTime.now().millisecondsSinceEpoch}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${DateTime.now().toString().split('.')[0]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close payment page
                },
                child: const Text('Done'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Generate and download receipt
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt download feature coming soon!'),
                    ),
                  );
                },
                child: const Text('Download Receipt'),
              ),
            ],
          ),
    );
  }
}
