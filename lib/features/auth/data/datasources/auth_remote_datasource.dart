import '../../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return response;
  }

  Future<Map<String, dynamic>> register(String email, String password, String firstName, String lastName) async {
    final response = await ApiClient.post('/auth/register', {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'role': 'tenant',
    });
    return response;
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await ApiClient.get('/auth/profile', token: token);
    return response;
  }
}
