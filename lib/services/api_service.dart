import 'dart:convert';
import 'dart:io';

import 'package:mouv_aps/services/secure_storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.53.15:8443/api';
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  static Future<Map<String, dynamic>> requestToken(
      String username, String password) async {
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

  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
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
    print(response.statusCode);
    return response.statusCode == HttpStatus.created
        ? jsonDecode(await response.transform(utf8.decoder).join())
        // display the error message
        : throw Exception(jsonDecode(
            await response.transform(utf8.decoder).join())["detail"]);
  }

  static Future<List<Map<String, dynamic>>> fetchSessions() async {
    final accessToken = await SecureStorageService().read('jwt_access');
    final uri = Uri.parse('$baseUrl/sessions/');
    final request = await _httpClient.getUrl(uri);

    // Add the Bearer token for authentication
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
    print(request.headers);

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      // Read response body
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> data = jsonDecode(responseBody);

      // Each item in 'data' is a Map<String, dynamic>
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
          'Failed to fetch sessions. Status: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRecipes() async {
    final accessToken = await SecureStorageService().read('jwt_access');
    final uri = Uri.parse('$baseUrl/recipes/');
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
      throw Exception(
          'Failed to fetch recipes. Status: ${response.statusCode}');
    }
  }

  static Future<String> getVideoURL(int id) async {
    final accessToken = await SecureStorageService().read('jwt_access');
    final uri = Uri.parse('$baseUrl/videos/$id/');
    final request = await _httpClient.getUrl(uri);
    print(uri);

    // Add the Bearer token for authentication
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
    print(request.headers);

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      // Read response body
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = jsonDecode(responseBody);

      // Get the video URL
      print(data["video_url"]);
      return data["video_url"];
    } else {
      throw Exception('Failed to fetch videos. Status: ${response.statusCode}');
    }
  }

  /// Uploads a PDF file
  static Future<Map<String, dynamic>> uploadPrescription({
    required File file,
  }) async {
    final uri = Uri.parse('$baseUrl/api/prescriptions/');
    final accessToken = SecureStorageService().read('jwt_access');
    final request = await _httpClient.postUrl(uri);

    const boundary = 'BOUNDARY123';
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'multipart/form-data; boundary=$boundary',
    );

    // Add Bearer token
    request.headers.set(
      HttpHeaders.authorizationHeader,
      'Bearer $accessToken',
    );

    // Build the multipart body manually

    // Read file bytes
    final fileBytes = await file.readAsBytes();
    // Extract file name (e.g. "prescription.pdf")
    final fileName = file.path.split(Platform.pathSeparator).last;

    // Start of multipart content
    final sb = StringBuffer()
          ..writeln('--$boundary')
          ..writeln(
              'Content-Disposition: form-data; name="file"; filename="$fileName"')
          ..writeln('Content-Type: application/pdf')
          ..writeln() // empty line to separate headers from file content
        ;

    // Convert the headers part to bytes
    final headerBytes = utf8.encode(sb.toString());

    // Closing boundary
    final closing = '\r\n--$boundary--\r\n';
    final closingBytes = utf8.encode(closing);

    // Write everything to the request
    //    (header, file content, then closing boundary)
    request.add(headerBytes);
    request.add(fileBytes);
    request.add(closingBytes);

    // Send the request and get the response
    final response = await request.close();

    // Process the response
    final responseString = await response.transform(utf8.decoder).join();
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      // Parse JSON on success
      return jsonDecode(responseString) as Map<String, dynamic>;
    } else {
      // Parse error JSON for "detail"
      final errorJson = jsonDecode(responseString);
      throw Exception(errorJson["detail"] ?? 'Unknown error uploading file.');
    }
  }
}
