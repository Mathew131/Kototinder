import 'package:get_it/get_it.dart';
import 'cat_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<CatProvider>(() => CatProvider());
}
