import "package:floor/floor.dart";

import '../entities/county_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class CountiesDao extends AbstractDao<CountyEntity> {
  @Query("SELECT * FROM counties")
  Future<List<CountyEntity>> getCounties();
}
