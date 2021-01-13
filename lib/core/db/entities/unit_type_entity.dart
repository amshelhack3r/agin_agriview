import 'package:AgriView/models/unit_type.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'unit_types')
class UnitTypeEntity extends UnitType {
  @PrimaryKey(autoGenerate: true)
  int id;
}
