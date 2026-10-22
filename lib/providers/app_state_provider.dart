import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/anime.dart';

class AppStateProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_anime';

  final List<Anime> _favorites = [];

  String _selectedGenre = 'All';
  String _homeSearchQuery = '';
  String _favoriteSearchQuery = '';

  AppStateProvider() {
    _loadFavorites();
  }

  List<Anime> get favorites => List.unmodifiable(_favorites);

  String get selectedGenre => _selectedGenre;
  String get homeSearchQuery => _homeSearchQuery;
  String get favoriteSearchQuery => _favoriteSearchQuery;

  void setSelectedGenre(String genre) {
    if (_selectedGenre == genre) return;
    _selectedGenre = genre;
    notifyListeners();
  }

  void setHomeSearchQuery(String query) {
    if (_homeSearchQuery == query) return;
    _homeSearchQuery = query;
    notifyListeners();
  }

  void setFavoriteSearchQuery(String query) {
    if (_favoriteSearchQuery == query) return;
    _favoriteSearchQuery = query;
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((anime) => anime.id == id);
  }

  void toggleFavorite(Anime anime) {
    if (isFavorite(anime.id)) {
      removeFavorite(anime.id);
    } else {
      addFavorite(anime);
    }
  }

  void addFavorite(Anime anime) {
    if (!isFavorite(anime.id)) {
      _favorites.add(anime);
      notifyListeners();
      _saveFavorites();
    }
  }

  void removeFavorite(String id) {
    final initialLength = _favorites.length;

    _favorites.removeWhere((anime) => anime.id == id);

    if (_favorites.length != initialLength) {
      notifyListeners();
      _saveFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null || favoritesJson.isEmpty) return;

      final List<dynamic> decodedData = jsonDecode(favoritesJson);

      final loadedFavorites = decodedData.map((item) {
        return Anime.fromMap(Map<String, dynamic>.from(item as Map));
      }).toList();

      _favorites
        ..clear()
        ..addAll(loadedFavorites);

      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat anime favorit: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String favoritesJson = jsonEncode(
        _favorites.map((anime) => anime.toMap()).toList(),
      );

      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Gagal menyimpan anime favorit: $e');
    }
  }
}
