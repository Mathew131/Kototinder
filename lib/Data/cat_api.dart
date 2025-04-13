import 'package:http/http.dart' as http;
import 'dart:convert';

class CatApi {
  static Future<dynamic> FutureRandomCat() async {
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
        dynamic data = jsonDecode(response.body);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
