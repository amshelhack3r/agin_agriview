import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_provider.dart';
import 'core/repository/api_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<ApiProvider>(ApiProvider());
  getIt.registerSingleton<ApiRepository>(
      ApiRepository(getIt.get<ApiProvider>()));

  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPrefs);
}
