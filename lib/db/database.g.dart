// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAgriviewDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AgriviewDatabaseBuilder databaseBuilder(String name) =>
      _$AgriviewDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AgriviewDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AgriviewDatabaseBuilder(null);
}

class _$AgriviewDatabaseBuilder {
  _$AgriviewDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AgriviewDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AgriviewDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AgriviewDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AgriviewDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AgriviewDatabase extends AgriviewDatabase {
  _$AgriviewDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CountiesDao _countyDaoInstance;

  CountryDao _countryDaoInstance;

  FarmDao _farmDaoInstance;

  FarmerDao _farmerDaoInstance;

  ProductDao _productDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `country` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `county` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `countyID` INTEGER, `countyName` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `farm` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `farmName` TEXT, `farmLocation` TEXT, `currentLandUse` TEXT, `producerAginId` TEXT, `lat` TEXT, `lon` TEXT, `acreageMapped` INTEGER, `acreageApproved` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `farmer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `firstName` TEXT, `lastName` TEXT, `phoneNumber` TEXT, `userAginID` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `product` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `fileName` TEXT, `UUID` TEXT, `productName` TEXT, `quantity` INTEGER, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `unit_types` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `unitTypeID` INTEGER, `unitTypeName` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cultivation_mode` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `id` INTEGER, `modeDescription` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CountiesDao get countyDao {
    return _countyDaoInstance ??= _$CountiesDao(database, changeListener);
  }

  @override
  CountryDao get countryDao {
    return _countryDaoInstance ??= _$CountryDao(database, changeListener);
  }

  @override
  FarmDao get farmDao {
    return _farmDaoInstance ??= _$FarmDao(database, changeListener);
  }

  @override
  FarmerDao get farmerDao {
    return _farmerDaoInstance ??= _$FarmerDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }
}

class _$CountiesDao extends CountiesDao {
  _$CountiesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _countyEntityInsertionAdapter = InsertionAdapter(
            database,
            'county',
            (CountyEntity item) => <String, dynamic>{
                  'id': item.id,
                  'countyID': item.countyID,
                  'countyName': item.countyName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CountyEntity> _countyEntityInsertionAdapter;

  @override
  Future<List<CountyEntity>> getCounties() async {
    return _queryAdapter.queryList('SELECT * FROM counties',
        mapper: (Map<String, dynamic> row) => CountyEntity());
  }

  @override
  Future<void> insertItem(CountyEntity item) async {
    await _countyEntityInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$CountryDao extends CountryDao {
  _$CountryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _countryEntityInsertionAdapter = InsertionAdapter(
            database,
            'country',
            (CountryEntity item) => <String, dynamic>{
                  'id': item.id,
                  'id': item.id,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CountryEntity> _countryEntityInsertionAdapter;

  @override
  Future<List<CountryEntity>> getCountries() async {
    return _queryAdapter.queryList('SELECT * FROM country',
        mapper: (Map<String, dynamic> row) => CountryEntity());
  }

  @override
  Future<void> insertItem(CountryEntity item) async {
    await _countryEntityInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$FarmDao extends FarmDao {
  _$FarmDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _farmEntityInsertionAdapter = InsertionAdapter(
            database,
            'farm',
            (FarmEntity item) => <String, dynamic>{
                  'id': item.id,
                  'farmName': item.farmName,
                  'farmLocation': item.farmLocation,
                  'currentLandUse': item.currentLandUse,
                  'producerAginId': item.producerAginId,
                  'lat': item.lat,
                  'lon': item.lon,
                  'acreageMapped': item.acreageMapped,
                  'acreageApproved': item.acreageApproved
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FarmEntity> _farmEntityInsertionAdapter;

  @override
  Future<List<FarmEntity>> getFarms() async {
    return _queryAdapter.queryList('SELECT * FROM farm',
        mapper: (Map<String, dynamic> row) => FarmEntity());
  }

  @override
  Future<void> insertItem(FarmEntity item) async {
    await _farmEntityInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$FarmerDao extends FarmerDao {
  _$FarmerDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _farmerEntityInsertionAdapter = InsertionAdapter(
            database,
            'farmer',
            (FarmerEntity item) => <String, dynamic>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'phoneNumber': item.phoneNumber,
                  'userAginID': item.userAginID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FarmerEntity> _farmerEntityInsertionAdapter;

  @override
  Future<List<FarmerEntity>> getFarmers() async {
    return _queryAdapter.queryList('SELECT * FROM farmer',
        mapper: (Map<String, dynamic> row) => FarmerEntity());
  }

  @override
  Future<void> insertItem(FarmerEntity item) async {
    await _farmerEntityInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _produceEntityInsertionAdapter = InsertionAdapter(
            database,
            'product',
            (ProduceEntity item) => <String, dynamic>{
                  'id': item.id,
                  'fileName': item.fileName,
                  'UUID': item.UUID,
                  'productName': item.productName,
                  'quantity': item.quantity,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProduceEntity> _produceEntityInsertionAdapter;

  @override
  Future<List<ProduceEntity>> getProducts() async {
    return _queryAdapter.queryList('SELECT * FROM product',
        mapper: (Map<String, dynamic> row) => ProduceEntity());
  }

  @override
  Future<void> insertItem(ProduceEntity item) async {
    await _produceEntityInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }
}
