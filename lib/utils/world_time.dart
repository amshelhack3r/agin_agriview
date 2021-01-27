import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String url;
  String flag;
  bool isDayTime;

  WorldTime({this.location, this.flag, this.time, this.url});

  Future<void> getWorldTime() async {
    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      time = DateFormat.jm().format(now);

      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
    } catch (e) {
      time = 'could not return time';
    }
  }
}
