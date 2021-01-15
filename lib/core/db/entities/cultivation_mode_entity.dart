import 'package:floor/floor.dart';

import '../../../models/cultivation_mode.dart';

@Entity(tableName: 'modes')
class CultivationModeEntity extends CultivationMode {
  @PrimaryKey(autoGenerate: true)
  int uid;
}
