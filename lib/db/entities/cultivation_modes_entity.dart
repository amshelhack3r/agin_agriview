import 'package:AgriView/models/cultivation_mode.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'cultivation_mode')
class CultivationEntity extends CultivationMode {
  @PrimaryKey(autoGenerate: true)
  int id;
}
