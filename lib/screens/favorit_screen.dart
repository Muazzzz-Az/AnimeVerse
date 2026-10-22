import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/favorite_anime_card.dart';
import '../widgets/search_field.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = context.watch<AppStateProvider>();

    if (_searchController.text != provider.favoriteSearchQuery) {
      _searchController.value = TextEditingValue(
        text: provider.favoriteSearchQuery,
        selection: TextSelection.collapsed(
          offset: provider.favoriteSearchQuery.length,
        ),
      );
    }

    final favorites = provider.favorites;
    final query = provider.favoriteSearchQuery.trim().toLowerCase();

    final filteredFavorites = favorites.where((anime) {
      return anime.title.toLowerCase().contains(query);
    }).toList();

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Anime',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchField(
            controller: _searchController,
            hintText: 'Anime Title',
            showClear: provider.favoriteSearchQuery.isNotEmpty,
            onChanged: provider.setFavoriteSearchQuery,
            onClear: () {
              _searchController.clear();
              provider.setFavoriteSearchQuery('');
            },
          ),
          Expanded(
            child: favorites.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 32,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Belum ada anime favorit',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : filteredFavorites.isEmpty
                ? const Center(
                    child: Text(
                      'Anime tidak ditemukan',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                    ),
                    itemCount: filteredFavorites.length,
                    itemBuilder: (context, index) {
                      final anime = filteredFavorites[index];

                      return FavoriteAnimeCard(
                        id: anime.id,
                        title: anime.title,
                        genre: anime.genre,
                        rating: anime.rating,
                        imagePath: anime.imagePath,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
