import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'Domain/cat_page.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<ConnectivityResult> _con;
  bool? _lastOnline;

  @override
  void initState() {
    super.initState();

    Connectivity().checkConnectivity().then((result) {
      _handleConnectivity(result);
    });

    _con = Connectivity().onConnectivityChanged.listen(_handleConnectivity);
  }

  void _handleConnectivity(ConnectivityResult result) {
    final online = result != ConnectivityResult.none;
    if (_lastOnline == null || _lastOnline != online) {
      _lastOnline = online;

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            online
                ? 'Есть подключение к интернету'
                : 'Нет подключения к интернету',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _con.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Kototinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatPage(),
    );
  }
}
