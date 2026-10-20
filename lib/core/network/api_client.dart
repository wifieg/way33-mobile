import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

/// Transport only. Business mutations must be implemented server-side.
class ApiClient {
  final http.Client client;
  final Uri baseUrl;
  ApiClient({required this.client, required this.baseUrl}) {
    if (baseUrl.scheme != 'https' && baseUrl.host != 'localhost') {
      throw ArgumentError('A HTTPS API endpoint is required');
    }
  }

  Future<Map<String, dynamic>> getJson(String path,
      {String? accessToken}) async {
    final endpoint =
        baseUrl.resolve(path.startsWith('/') ? path.substring(1) : path);
    final response = await client.get(endpoint, headers: {
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    }).timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, 'Server request failed');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON object');
    }
    return data;
  }
}
