import 'package:flutter/material.dart';

class CatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _likedCats = [];
  int _likeCount = 0;

  List<Map<String, dynamic>> get likedCats => _likedCats;
  int get likeCount => _likeCount;

  void like(String name, String url, DateTime time) {
    _likedCats.add({'name': name, 'url': url, 'time': time});
    _likeCount++;
    notifyListeners();
  }

  void remove(int index) {
    _likedCats.removeAt(index);
    notifyListeners();
  }
}
