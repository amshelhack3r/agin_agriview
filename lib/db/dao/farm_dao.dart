import "package:floor/floor.dart";

import '../entities/farm_entity.dart';

@dao
abstract class FarmDao {
  @Query("SELECT * FROM farm")
  Future<List<FarmEntity>> getFarms();

  @insert
  Future<void> insertFarm(FarmEntity farm);
}
