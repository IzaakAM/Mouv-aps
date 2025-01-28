import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'https://192.168.72.204:8443/api';
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
    print(username);
    print(password);

    final response = await request.close();
    return response.statusCode == HttpStatus.ok
        ? jsonDecode(await response.transform(utf8.decoder).join())
        : throw Exception('Failed to login');
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
}