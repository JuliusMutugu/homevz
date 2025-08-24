import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final options = Options();
      if (token != null) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
      
      final response = await _dio.get(endpoint, options: options);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final options = Options();
      if (token != null) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
      
      final response = await _dio.post(endpoint, data: data, options: options);
      return response.data;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final options = Options();
      if (token != null) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
      
      final response = await _dio.put(endpoint, data: data, options: options);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    try {
      final options = Options();
      if (token != null) {
        options.headers = {'Authorization': 'Bearer $token'};
      }
      
      final response = await _dio.delete(endpoint, options: options);
      return response.data;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }
}
