import 'package:floor/floor.dart';

import '../../../models/unit_type.dart';

@Entity(tableName: 'unit_types')
class UnitTypeEntity extends UnitType {
  @PrimaryKey(autoGenerate: true)
  int id;
}
