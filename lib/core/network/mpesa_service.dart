import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

/// M-Pesa response models
class MpesaTokenResponse {
  final bool success;
  final String? token;
  final String? expiresIn;
  final String? error;

  MpesaTokenResponse({
    required this.success,
    this.token,
    this.expiresIn,
    this.error,
  });
}

class MpesaPaymentResponse {
  final bool success;
  final String? checkoutRequestId;
  final String? merchantRequestId;
  final String? responseCode;
  final String? responseDescription;
  final String? customerMessage;
  final String? error;

  MpesaPaymentResponse({
    required this.success,
    this.checkoutRequestId,
    this.merchantRequestId,
    this.responseCode,
    this.responseDescription,
    this.customerMessage,
    this.error,
  });
}

class MpesaQueryResponse {
  final bool success;
  final String? resultCode;
  final String? resultDesc;
  final String? mpesaReceiptNumber;
  final double? amount;
  final String? transactionDate;
  final String? phoneNumber;
  final String? error;

  MpesaQueryResponse({
    required this.success,
    this.resultCode,
    this.resultDesc,
    this.mpesaReceiptNumber,
    this.amount,
    this.transactionDate,
    this.phoneNumber,
    this.error,
  });
}

/// M-Pesa payment service for handling mobile money transactions in Kenya
class MpesaService {
  MpesaService._();
  
  static final Logger _logger = Logger();
  static const String _baseUrl = 'https://sandbox.safaricom.co.ke';
  static const String _consumerKey = 'your_consumer_key';
  static const String _consumerSecret = 'your_consumer_secret';
  
  /// Payment result enum
  static const String paymentSuccess = 'SUCCESS';
  static const String paymentFailed = 'FAILED';
  static const String paymentCancelled = 'CANCELLED';
  static const String paymentPending = 'PENDING';
  
  /// Generate OAuth token for M-Pesa API authentication
  static Future<MpesaTokenResponse> _generateToken() async {
    try {
      final credentials = base64Encode(
        utf8.encode('$_consumerKey:$_consumerSecret'),
      );
      
      final response = await http.get(
        Uri.parse('$_baseUrl/oauth/v1/generate?grant_type=client_credentials'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MpesaTokenResponse(
          success: true,
          token: data['access_token'],
          expiresIn: data['expires_in'],
        );
      }
      
      _logger.e('Failed to generate M-Pesa token: ${response.statusCode}');
      return MpesaTokenResponse(
        success: false,
        error: 'Failed to authenticate with M-Pesa API',
      );
    } catch (e) {
      _logger.e('Error generating M-Pesa token: $e');
      return MpesaTokenResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
  
  /// Initiate STK Push for rent payment
  static Future<MpesaPaymentResponse> stkPush({
    required String phoneNumber,
    required double amount,
    required String accountReference,
    required String transactionDesc,
  }) async {
    try {
      final tokenResponse = await _generateToken();
      if (!tokenResponse.success) {
        return MpesaPaymentResponse(
          success: false,
          error: tokenResponse.error ?? 'Failed to authenticate',
        );
      }
      
      final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
      final password = base64Encode(
        utf8.encode('${AppConstants.mpesaBusinessShortCode}${AppConstants.mpesaPasskey}$timestamp'),
      );
      
      final payload = {
        'BusinessShortCode': AppConstants.mpesaBusinessShortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.toInt(),
        'PartyA': phoneNumber,
        'PartyB': AppConstants.mpesaBusinessShortCode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': AppConstants.mpesaCallbackUrl,
        'AccountReference': accountReference,
        'TransactionDesc': transactionDesc,
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/mpesa/stkpush/v1/processrequest'),
        headers: {
          'Authorization': 'Bearer ${tokenResponse.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['ResponseCode'] == '0') {
        return MpesaPaymentResponse(
          success: true,
          checkoutRequestId: data['CheckoutRequestID'],
          merchantRequestId: data['MerchantRequestID'],
          responseCode: data['ResponseCode'],
          responseDescription: data['ResponseDescription'],
          customerMessage: data['CustomerMessage'],
        );
      }
      
      return MpesaPaymentResponse(
        success: false,
        error: data['ResponseDescription'] ?? 'Payment initiation failed',
      );
    } catch (e) {
      _logger.e('Error initiating M-Pesa payment: $e');
      return MpesaPaymentResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }
  
  /// Check transaction status
  static Future<MpesaQueryResponse> queryTransaction({
    required String checkoutRequestId,
  }) async {
    try {
      final tokenResponse = await _generateToken();
      if (!tokenResponse.success) {
        return MpesaQueryResponse(
          success: false,
          error: tokenResponse.error ?? 'Failed to authenticate',
        );
      }
      
      final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
      final password = base64Encode(
        utf8.encode('${AppConstants.mpesaBusinessShortCode}${AppConstants.mpesaPasskey}$timestamp'),
      );
      
      final payload = {
        'BusinessShortCode': AppConstants.mpesaBusinessShortCode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': checkoutRequestId,
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/mpesa/stkpushquery/v1/query'),
        headers: {
          'Authorization': 'Bearer ${tokenResponse.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return MpesaQueryResponse(
          success: true,
          resultCode: data['ResultCode'],
          resultDesc: data['ResultDesc'],
          mpesaReceiptNumber: data['MpesaReceiptNumber'],
          amount: data['Amount']?.toDouble(),
          transactionDate: data['TransactionDate'],
          phoneNumber: data['PhoneNumber'],
        );
      }
      
      return MpesaQueryResponse(
        success: false,
        error: data['ResultDesc'] ?? 'Query failed',
      );
    } catch (e) {
      _logger.e('Error querying M-Pesa transaction: $e');
      return MpesaQueryResponse(
        success: false,
        error: 'Network error: $e',
      );
    }
  }

  /// Validate Kenyan phone number for M-Pesa
  static bool isValidMpesaPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Check for valid Kenyan mobile formats
    return RegExp(r'^(254|0)?(7[0-9]{8}|1[01][0-9]{7})$').hasMatch(cleaned);
  }

  /// Format phone number to M-Pesa format
  static String formatMpesaPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.startsWith('254')) {
      return cleaned;
    } else if (cleaned.startsWith('0')) {
      return '254${cleaned.substring(1)}';
    } else if (cleaned.length == 9) {
      return '254$cleaned';
    }
    
    return cleaned;
  }

  /// Get payment status from result code
  static String getPaymentStatus(String? resultCode) {
    switch (resultCode) {
      case '0':
        return paymentSuccess;
      case '1032':
        return paymentCancelled;
      case '1':
      case '1025':
      case '1026':
      case '1027':
      case '1028':
      case '1029':
      case '1030':
      case '1031':
        return paymentFailed;
      default:
        return paymentPending;
    }
  }
}
