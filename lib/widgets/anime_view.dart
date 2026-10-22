import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dummy_data.dart';
import '../models/anime.dart';
import '../providers/app_state_provider.dart';
import 'anime_card.dart';

class AnimeView extends StatelessWidget {
  final String selectedGenre;

  const AnimeView({super.key, this.selectedGenre = 'All'});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final query = provider.homeSearchQuery.trim().toLowerCase();

        final List<Anime> filteredAnime = DummyData.animeList.where((anime) {
          final matchesGenre =
              selectedGenre == 'All' ||
              anime.genre
                  .toLowerCase()
                  .split(',')
                  .map((genre) => genre.trim())
                  .contains(selectedGenre.toLowerCase());

          final matchesSearch = anime.title.toLowerCase().contains(query);

          return matchesGenre && matchesSearch;
        }).toList();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              double childAspectRatio;

              if (constraints.maxWidth < 600) {
                crossAxisCount = 3;
                childAspectRatio = 0.55;
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 5;
                childAspectRatio = 0.6;
              } else {
                crossAxisCount = (constraints.maxWidth / 200).floor().clamp(
                  4,
                  6,
                );
                childAspectRatio = 0.8;
              }

              if (filteredAnime.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Anime tidak ditemukan.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: constraints.maxWidth * 0.03,
                  crossAxisSpacing: constraints.maxWidth * 0.05,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: filteredAnime.length,
                itemBuilder: (context, index) {
                  final anime = filteredAnime[index];

                  return AnimeCard(
                    id: anime.id,
                    title: anime.title,
                    imagePath: anime.imagePath,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
