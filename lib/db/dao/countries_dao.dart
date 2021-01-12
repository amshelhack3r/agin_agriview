import "package:floor/floor.dart";

import '../entities/country_entity.dart';

@dao
abstract class CountryDao {
  @Query("SELECT * FROM country")
  Future<List<CountryEntity>> getCountries();

  @insert
  Future<void> insertCountry(CountryEntity country);
}
