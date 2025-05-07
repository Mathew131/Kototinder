import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../Data/cat_api.dart';

class MockCatApi extends Mock implements CatApi {}

void main() {
  late MockCatApi mockApi;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockApi = MockCatApi();
  });

  test('CatApi возвращает список кота при status 200', () async {
    when(() => mockApi.FutureRandomCat()).thenAnswer(
      (_) async => [
        {
          'url': 'url1',
          'breeds': [
            {'name': 'Age'},
          ],
        },
      ],
    );

    final data = await mockApi.FutureRandomCat();
    expect(data, isA<List<dynamic>>());
    expect(data[0]['url'], 'url1');
  });
}
