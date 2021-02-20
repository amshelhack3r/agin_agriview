import 'package:floor/floor.dart';

import '../../../models/county.dart';

@Entity(tableName: 'county')
class CountyEntity extends County {
  @PrimaryKey(autoGenerate: true)
  int id;
}
