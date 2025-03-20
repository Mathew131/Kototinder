import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kototinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatPage(),
    );
  }
}

class CatPage extends StatefulWidget {
  const CatPage({super.key});
  @override
  State<CatPage> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  String _imageUrl = '';
  Map<String, dynamic>? _breedData;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _RandomCat();
  }

  Future<void> _RandomCat() async {
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=1',
    );
    try {
      final response = await http.get(
        url,
        headers: {
          'x-api-key':
              'live_NeHytbCpapkmF1vIGISn4dV7zkrxSAy0Su6uCCmtw5OVUgTIQbQKEQ4g2s08n4IE',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final catData = data.first;
          List<dynamic>? breeds = catData['breeds'];
          Map<String, dynamic>? breedInfo;
          if (breeds != null && breeds.isNotEmpty) {
            breedInfo = breeds.first;
          }
          setState(() {
            _imageUrl = catData['url'] ?? '';
            _breedData = breedInfo;
          });
        }
      } else {
        debugPrint('Ошибка при получении котика: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Исключение при получении котика: $e');
    }
  }

  void _onLike() {
    setState(() {
      _likeCount++;
    });
    _RandomCat();
  }

  void _onDislike() {
    _RandomCat();
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Like count: $_likeCount',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          _breedData != null
              ? (_breedData!['name'] ?? 'Unknown breed')
              : 'Unknown breed',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      child:
          _imageUrl.isNotEmpty
              ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CatDetailPage(
                            imageUrl: _imageUrl,
                            breedData: _breedData,
                          ),
                    ),
                  );
                },
                child: Image.network(_imageUrl, fit: BoxFit.contain),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDown(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DislikeButton(onPressed: _onDislike),
        LikeButton(onPressed: _onLike),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kototinder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Dismissible(
          key: ValueKey(_imageUrl),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              setState(() {
                _likeCount++;
              });
              await _RandomCat();
              return false;
            } else if (direction == DismissDirection.startToEnd) {
              await _RandomCat();
              return false;
            }
            return false;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(context),
              _buildImageSection(context),
              const SizedBox(height: 16),
              _buildDown(context),
            ],
          ),
        ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LikeButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.favorite),
      label: const Text('Like'),
    );
  }
}

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DislikeButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      label: const Text('Dislike'),
    );
  }
}

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
            Image.network(imageUrl, height: 300, fit: BoxFit.cover),
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
              Text(
                'Подробнее: $wikipediaUrl',
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
