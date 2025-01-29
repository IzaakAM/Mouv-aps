import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'https://192.168.122.1:8443/api';
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  static Future<Map<String, dynamic>> requestToken(String username, String password) async {
    final uri = Uri.parse('$baseUrl/token/');
    final request = await _httpClient.postUrl(uri);

    // Add request headers and body
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'username': username,
      'password': password,
    }));

    final response = await request.close();
    return response.statusCode == HttpStatus.ok
        ? jsonDecode(await response.transform(utf8.decoder).join())
        : throw Exception('Failed to login');
  }

  static Future<Map<String, dynamic>> requestGuestToken() async {
    final uri = Uri.parse('$baseUrl/guest-token/');
    final request = await _httpClient.getUrl(uri);

    final response = await request.close();
    return response.statusCode == HttpStatus.ok
        ? jsonDecode(await response.transform(utf8.decoder).join())
        : throw Exception('Failed to connect');
  }

  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final uri = Uri.parse('$baseUrl/register/');
    final request = await _httpClient.postUrl(uri);

    // Add request headers and body
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'username': username,
      'password': password,
      'email': email,
    }));


    final response = await request.close();
    return response.statusCode == HttpStatus.created
        ? jsonDecode(await response.transform(utf8.decoder).join())
    // display the error message
        : throw Exception(jsonDecode(await response.transform(utf8.decoder)
        .join())["detail"]);
  }

  static Future<List<Map<String, dynamic>>> fetchSessions(String accessToken) async {
    final uri = Uri.parse('$baseUrl/sessions/');
    final request = await _httpClient.getUrl(uri);

    // Add the Bearer token for authentication
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      // Read response body
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> data = jsonDecode(responseBody);

      // Each item in 'data' is a Map<String, dynamic>
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch sessions. Status: ${response.statusCode}');
    }
  }
}