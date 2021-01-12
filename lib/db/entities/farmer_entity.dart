import 'package:AgriView/models/farmer_info.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'farmer')
class FarmerEntity extends FarmerInfo {
  @PrimaryKey(autoGenerate: true)
  int id;
}
