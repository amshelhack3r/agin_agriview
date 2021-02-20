import 'package:floor/floor.dart';

import '../../../models/cultivation_mode.dart';

@Entity(tableName: 'cultivation_mode')
class CultivationEntity extends CultivationMode {
  @PrimaryKey(autoGenerate: true)
  int uid;
}
