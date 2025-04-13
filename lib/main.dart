import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Domain/cat_provider.dart';
import 'Domain/locator.dart';
import 'app.dart';

void main() {
  setupLocator();
  runApp(ChangeNotifierProvider(create: (_) => CatProvider(), child: MyApp()));
}
