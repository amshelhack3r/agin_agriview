import 'package:shared_preferences/shared_preferences.dart';

import '../../models/county.dart';
import '../../models/login_object.dart';
import '../../utils/constants.dart';
import '../api/api_provider.dart';
import '../db/entities/county_entity.dart';
import 'local_repository.dart';
import 'repository.dart';

class ApiRepository extends Repository {
  @override
  String getType() => 'api';
  ApiProvider _apiProvider;
  ApiRepository() {
    _apiProvider = ApiProvider();
  }

  Future<AggregatorLoginObject> loginUser(Map params) async {
    var result = await _apiProvider.loginAggregator(params);

    if (result.isRight) {
      //save user to shared preferences
      var user = AggregatorLoginObject.fromMap(result.right);

      var preferences = await SharedPreferences.getInstance();
      preferences.setString(PREF_NAME, user.fullName);
      preferences.setString(PREF_AGINID, user.youthAGINID);
      preferences.setString(PREF_MOBILE, user.phoneNumber);
      preferences.setBool(PREF_HAS_LOGGED_IN, true);

      return user;
    } else {
      throw result.left;
    }
    return (result.isRight)
        ? AggregatorLoginObject.fromMap(result.right)
        : throw result.left;
  }

  Future createUser(Map params) async {
    var result = await _apiProvider.createAggregator(params);

    return (result.isRight) ? "User Created Successfully" : result.left.message;
  }

  Future verifyUser(Map params) async {
    var result = await _apiProvider.verifyAccount(
        params["phoneNumber"], params["verifyCode"]);

    return result;
  }

  Future fetchCounty() async {
    var result = await _apiProvider.fetchCounty();

    if (result.isRight) {
      var database = await LocalRepository.getInstance();
      result.right.map((county) {
        CountyEntity cty = County.fromMap(county);
        database.countyDao.insertItem(cty);
      });
    } else {
      throw result.left;
    }
  }
}
