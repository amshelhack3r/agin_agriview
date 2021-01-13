import 'package:AgriView/models/farm.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'farm')
class FarmEntity extends Farm {
  @PrimaryKey(autoGenerate: true)
  int id;
}
