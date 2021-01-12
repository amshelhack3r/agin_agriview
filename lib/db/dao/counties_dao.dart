import "package:floor/floor.dart";

import '../entities/county_entity.dart';

@dao
abstract class CountiesDao {
  @Query("SELECT * FROM counties")
  Future<List<CountyEntity>> getCounties();

  @insert
  Future<void> insertCounty(CountyEntity county);
}
