import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _likedCats = [];
  int _likeCount = 0;

  List<Map<String, dynamic>> get likedCats => _likedCats;
  int get likeCount => _likeCount;

  CatProvider() {
    _loadData();
  }

  void like(String name, String url, DateTime time) {
    _likedCats.add({'name': name, 'url': url, 'time': time});
    _likeCount++;
    _saveData();
    notifyListeners();
  }

  void remove(int index) {
    _likedCats.removeAt(index);
    _likeCount--;
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final catJsonList =
        _likedCats.map((cat) {
          return jsonEncode(
            cat,
            toEncodable: (nonEnc) {
              if (nonEnc is DateTime) return nonEnc.toIso8601String();
              return nonEnc;
            },
          );
        }).toList();

    await prefs.setStringList('likedCats', catJsonList);
    await prefs.setInt('likeCount', _likeCount);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final catJsonList = prefs.getStringList('likedCats') ?? [];
    _likedCats =
        catJsonList.map((cat) {
          final decoded = jsonDecode(cat);
          return {
            'name': decoded['name'],
            'url': decoded['url'],
            'time': DateTime.parse(decoded['time']),
          };
        }).toList();
    _likeCount = prefs.getInt('likeCount') ?? 0;
    notifyListeners();
  }
}
