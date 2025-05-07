import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Domain/cat_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CatProvider', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('like()', () async {
      final p = CatProvider();
      final now = DateTime.now();

      p.like('Barsik', 'url1', now);

      expect(p.likeCount, 1);
      expect(p.likedCats, [
        {'name': 'Barsik', 'url': 'url1', 'time': now},
      ]);
    });
  });
}
