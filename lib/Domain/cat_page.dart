import 'package:flutter/material.dart';
import 'liked_cats.dart';
import '../Data/cat_api.dart';
import '../Presentation/buttons.dart';
import 'cat_detail_page.dart';
import 'cat_provider.dart';
import 'locator.dart';

class CatPage extends StatefulWidget {
  const CatPage({super.key});
  @override
  State<CatPage> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  String _imageUrl = '';
  Map<String, dynamic>? _breedData;
  dynamic data;

  @override
  void initState() {
    super.initState();
    _RandomCat();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ошибка сети'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ОК'),
              ),
            ],
          ),
    );
  }

  Future<void> _RandomCat() async {
    data = await CatApi.FutureRandomCat();

    if (data == null) {
      _showErrorDialog('Ошибка загрузки кота');
      return;
    }
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
  }

  void _onLikedCates() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LikedCats()),
    );
  }

  void _onLike() {
    setState(() {
      if (data is List && data.isNotEmpty) {
        final catData = data.first;
        List<dynamic>? breeds = catData['breeds'];
        Map<String, dynamic>? breedInfo;
        if (breeds != null && breeds.isNotEmpty) {
          breedInfo = breeds.first;
          locator<CatProvider>().like(
            breedInfo?['name'] ?? 'Unknown breed',
            _imageUrl,
            DateTime.now(),
          );
        }
      }
    });
    _RandomCat();
  }

  void _onDislike() {
    _RandomCat();
  }

  Widget _buildHeader(BuildContext context) {
    dynamic _lc = locator<CatProvider>().likeCount;
    return Column(
      children: [
        Text('Like count: $_lc', style: Theme.of(context).textTheme.titleLarge),
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
        const SizedBox(width: 8),
        LikedCatsButton(onPressed: _onLikedCates),
        const SizedBox(width: 8),
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
              _onLike();
            } else if (direction == DismissDirection.startToEnd) {
              _onDislike();
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
