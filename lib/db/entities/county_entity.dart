import 'package:AgriView/models/county.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'county')
class CountyEntity extends County {
  @PrimaryKey(autoGenerate: true)
  int id;
}
