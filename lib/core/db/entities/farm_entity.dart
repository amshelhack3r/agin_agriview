import 'package:floor/floor.dart';

import '../../../models/farm.dart';

@Entity(tableName: 'farm')
class FarmEntity extends Farm {
  @PrimaryKey(autoGenerate: true)
  int id;
}
