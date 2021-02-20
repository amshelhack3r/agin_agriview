import 'package:floor/floor.dart';

import '../../../models/country.dart';

@Entity(tableName: 'country')
class CountryEntity extends Country {
  @PrimaryKey(autoGenerate: true)
  int uid;
}
