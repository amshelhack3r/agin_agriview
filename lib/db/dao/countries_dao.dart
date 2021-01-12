import "package:floor/floor.dart";

import '../entities/country_entity.dart';
import 'abstract_dao.dart';

@dao
abstract class CountryDao extends AbstractDao<CountryEntity> {
  @Query("SELECT * FROM country")
  Future<List<CountryEntity>> getCountries();
}
