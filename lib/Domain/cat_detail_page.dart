import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatDetailPage extends StatelessWidget {
  final String imageUrl;
  final Map<String, dynamic>? breedData;
  const CatDetailPage({super.key, required this.imageUrl, this.breedData});
  @override
  Widget build(BuildContext context) {
    final breedName = breedData?['name'] ?? 'Unknown breed';
    final origin = breedData?['origin'] ?? 'Unknown origin';
    final description = breedData?['description'] ?? 'No description';
    final temperament = breedData?['temperament'] ?? 'Unknown temperament';
    final lifeSpan = breedData?['life_span'] ?? 'No info';
    final wikipediaUrl = breedData?['wikipedia_url'];
    return Scaffold(
      appBar: AppBar(title: const Text('Cat Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(breedName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Origin: $origin'),
            const SizedBox(height: 8),
            Text('Life Span: $lifeSpan'),
            const SizedBox(height: 8),
            Text('Temperament: $temperament'),
            const SizedBox(height: 16),
            Text(description),
            const SizedBox(height: 16),
            if (wikipediaUrl != null)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: wikipediaUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ссылка скопирована')),
                  );
                },
                child: Text(
                  'Подробнее: $wikipediaUrl',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
