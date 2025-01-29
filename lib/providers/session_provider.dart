import 'package:flutter/material.dart';
import 'package:mouv_aps/models/session.dart';
import 'package:mouv_aps/services/api_service.dart';
import 'package:mouv_aps/services/secure_storage_service.dart';

class SessionProvider with ChangeNotifier {
  List<Session> _sessions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // 3) Load sessions from the server
  Future<void> loadSessions() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Retrieve the stored token
      final String? accessToken =
      await SecureStorageService().read('jwt_access');
      if (accessToken == null) {
        throw Exception("No access token found");
      }

      // Call the service
      final rawSessions = await ApiService.fetchSessions(accessToken);

      // Convert each item to a Session model
      final loaded = rawSessions.map((json) => Session.fromJson(json)).toList();

      _sessions = loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _sessions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
