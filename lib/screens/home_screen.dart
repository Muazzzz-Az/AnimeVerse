import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iklc_anime_verse/widgets/genre_list.dart';

import '../providers/app_state_provider.dart';
import '../widgets/anime_view.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    if (_searchController.text != provider.homeSearchQuery) {
      _searchController.value = TextEditingValue(
        text: provider.homeSearchQuery,
        selection: TextSelection.collapsed(
          offset: provider.homeSearchQuery.length,
        ),
      );
    }

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'AnimeVerse',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.075,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchField(
              controller: _searchController,
              hintText: 'Anime Title',
              showClear: provider.homeSearchQuery.isNotEmpty,
              onChanged: provider.setHomeSearchQuery,
              onClear: () {
                _searchController.clear();
                provider.setHomeSearchQuery('');
              },
            ),
            GenreList(
              selected: provider.selectedGenre,
              onGenreSelected: (genre) {
                debugPrint('Genre diklik: $genre');
                provider.setSelectedGenre(genre);
                debugPrint('Genre aktif: ${provider.selectedGenre}');
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            AnimeView(selectedGenre: provider.selectedGenre),
            SizedBox(height: screenHeight * 0.025),
          ],
        ),
      ),
    );
  }
}

