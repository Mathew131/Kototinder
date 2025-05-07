import 'package:flutter/material.dart';
import 'cat_provider.dart';
import 'locator.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DeleteCatsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteCatsButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.close),
      label: const Text('Delete Cat'),
    );
  }
}

class LikedCats extends StatefulWidget {
  @override
  State<LikedCats> createState() => _LikedCatsState();
}

class _LikedCatsState extends State<LikedCats> {
  late List<Map<String, dynamic>> _cats;
  String? selectedBreed;

  @override
  void initState() {
    super.initState();
    _cats = locator<CatProvider>().likedCats;
  }

  void _onLikedCats(Map<String, dynamic> cat) {
    setState(() {
      final index = _cats.indexOf(cat);
      if (index != -1) {
        locator<CatProvider>().remove(index);
      }

      final updatedBreeds = _cats.map((c) => c['name'] as String).toSet();
      if (!updatedBreeds.contains(selectedBreed)) {
        selectedBreed = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> allBreeds =
        _cats.map((cat) => cat['name'] as String).toSet().toList();

    dynamic filteredCats =
        selectedBreed == null
            ? _cats
            : _cats.where((cat) => cat['name'] == selectedBreed).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Cats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButton<String>(
              value: selectedBreed,
              hint: const Text('Выбери породу'),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('All')),
                ...allBreeds.map<DropdownMenuItem<String>>((breed) {
                  return DropdownMenuItem<String>(
                    value: breed,
                    child: Text(breed),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  selectedBreed = value;
                });
              },
            ),

            Column(
              children: [
                for (int i = 0; i < filteredCats.length; ++i)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: filteredCats[i]['url'],
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                children: [
                                  Text(
                                    filteredCats[i]['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormat(
                                      'dd.MM.yyyy HH:mm',
                                    ).format(filteredCats[i]['time']),
                                  ),
                                  const SizedBox(height: 6),
                                  DeleteCatsButton(
                                    onPressed:
                                        () => _onLikedCats(filteredCats[i]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
