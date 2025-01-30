import 'package:flutter/material.dart';
import 'package:mouv_aps/models/recipe.dart';
import 'package:mouv_aps/services/api_service.dart';
import 'package:mouv_aps/services/secure_storage_service.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadRecipes() async {
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
      final rawRecipes = await ApiService.fetchRecipes();

      // Convert each item to a Session model
      final loaded = rawRecipes.map((json) => Recipe.fromJson(json)).toList();

      _recipes = loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _recipes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
