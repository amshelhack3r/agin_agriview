import 'dart:async';

import 'package:floor/floor.dart';

import 'dao/counties_dao.dart';
import 'dao/countries_dao.dart';
import 'dao/farm_dao.dart';
import 'dao/farmer_dao.dart';
import 'dao/product_dao.dart';
import 'entities/country_entity.dart';
import 'entities/county_entity.dart';
import 'entities/cultivation_modes_entity.dart';
import 'entities/farm_entity.dart';
import 'entities/farmer_entity.dart';
import 'entities/produce_entity.dart';
import 'entities/unit_type_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  CountryEntity,
  CountyEntity,
  FarmEntity,
  FarmerEntity,
  ProduceEntity,
  UnitTypeEntity,
  CultivationEntity
])
abstract class AgriviewDatabase extends FloorDatabase {
  CountiesDao get countyDao;
  CountryDao get countryDao;
  FarmDao get farmDao;
  FarmerDao get farmerDao;
  ProductDao get productDao;
}
