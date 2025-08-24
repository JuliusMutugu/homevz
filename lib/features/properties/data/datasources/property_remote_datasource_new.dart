import '../../../../core/network/api_client.dart';

class PropertyRemoteDataSource {
  static Future<List<dynamic>> getProperties() async {
    try {
      final response = await ApiClient.get('/properties');
      // Since ApiClient.get returns Map<String, dynamic>, handle accordingly
      if (response.containsKey('data')) {
        return response['data'] as List<dynamic>;
      }
      // If the response structure is different, adapt as needed
      return []; // Return empty list as fallback
    } catch (e) {
      throw Exception('Failed to fetch properties: $e');
    }
  }

  static Future<Map<String, dynamic>?> getPropertyById(String id) async {
    try {
      final response = await ApiClient.get('/properties/$id');
      // Since ApiClient.get returns Map<String, dynamic>, handle accordingly
      if (response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      return response; // Return the response directly
    } catch (e) {
      throw Exception('Failed to fetch property: $e');
    }
  }
}
