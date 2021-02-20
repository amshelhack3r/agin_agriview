import 'package:floor/floor.dart';

import '../../../models/cultivation_mode.dart';
import '../entities/cultivation_mode_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class CultivationDao extends AbstractDao<CultivationModeEntity> {
  @Query("SELECT * FROM modes")
  Future<List<CultivationMode>> getModes();
}
