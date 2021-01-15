import 'package:AgriView/core/db/dao/abstract_dao.dart';
import 'package:AgriView/core/db/entities/cultivation_mode_entity.dart';
import 'package:AgriView/models/cultivation_mode.dart';
import 'package:floor/floor.dart';

@dao
abstract class CultivationDao extends AbstractDao<CultivationModeEntity> {
  @Query("SELECT * FROM modes")
  Future<List<CultivationMode>> getModes();
}
