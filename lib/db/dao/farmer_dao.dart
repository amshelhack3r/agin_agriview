import "package:floor/floor.dart";

import '../entities/farmer_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class FarmerDao extends AbstractDao<FarmerEntity> {
  @Query("SELECT * FROM farmer")
  Future<List<FarmerEntity>> getFarmers();
}
