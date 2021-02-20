import 'package:floor/floor.dart';

import '../../../models/farmer_info.dart';

@Entity(tableName: 'farmer')
class FarmerEntity extends FarmerInfo {
  @PrimaryKey(autoGenerate: true)
  int id;
}
