import "package:floor/floor.dart";

import '../entities/farmer_entity.dart';

@dao
abstract class FarmerDao {
  @Query("SELECT * FROM farmer")
  Future<List<FarmerEntity>> getFarmers();

  @insert
  Future<void> insertFarmer(FarmerEntity farmInfo);
}
