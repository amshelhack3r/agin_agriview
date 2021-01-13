import '../db/database.dart';
import 'repository.dart';

class LocalRepository extends Repository {
  static Future<AgriviewDatabase> getInstance() async {
    return await $FloorAgriviewDatabase.databaseBuilder("agriview").build();
  }

  @override
  String getType() => 'local';
}
