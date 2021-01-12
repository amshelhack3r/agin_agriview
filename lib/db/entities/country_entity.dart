import 'package:AgriView/models/country.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'country')
class CountryEntity extends Country {
  @PrimaryKey(autoGenerate: true)
  int id;
}
