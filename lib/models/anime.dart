
class Anime {
  final String id;
  final String title;
  final String imagePath;
  final String genre;
  final String rating;
  final String totalEpisodes;
  final String description;

  const Anime({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.genre,
    required this.rating,
    required this.totalEpisodes,
    required this.description,
  });

  // Mengubah objek Anime menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'genre': genre,
      'rating': rating,
      'totalEpisodes': totalEpisodes,
      'description': description,
    };
  }

  // Mengubah Map menjadi objek Anime
  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      id: map['id'] as String,
      title: map['title'] as String,
      imagePath: map['imagePath'] as String,
      genre: map['genre'] as String,
      rating: map['rating'] as String,
      totalEpisodes: map['totalEpisodes'] as String,
      description: map['description'] as String,
    );
  }
}
