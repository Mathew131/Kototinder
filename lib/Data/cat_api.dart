import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';

class CatApi {
  final _r = RetryOptions(maxAttempts: 50);

  Future<dynamic> FutureRandomCat() {
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=1',
    );

    return _r.retry(() async {
      final response = await http.get(
        url,
        headers: {
          'x-api-key':
              'live_NeHytbCpapkmF1vIGISn4dV7zkrxSAy0Su6uCCmtw5OVUgTIQbQKEQ4g2s08n4IE',
        },
      );
      if (response.statusCode != 200)
        throw Exception('status ${response.statusCode}');
      return jsonDecode(response.body) as List<dynamic>;
    }, retryIf: (_) => true);
  }
}
