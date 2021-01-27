import 'package:get_it/get_it.dart';

import 'core/api/api_provider.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ApiProvider>(ApiProvider());
}
