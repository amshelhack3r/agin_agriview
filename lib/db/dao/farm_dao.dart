import "package:floor/floor.dart";

import '../entities/farm_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class FarmDao extends AbstractDao<FarmEntity> {
  @Query("SELECT * FROM farm")
  Future<List<FarmEntity>> getFarms();
}
