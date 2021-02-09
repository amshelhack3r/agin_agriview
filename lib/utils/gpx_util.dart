import 'dart:io';

import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';

class GpxUtil {
  final double lat;
  final double lon;
  final double elevation;
  final String name;
  final String desc;
  GpxUtil({
    this.lat,
    this.lon,
    this.elevation,
    this.name,
    this.desc,
  });

  Future<File> writeToFile() async {
    final file = await _localFile;

    // create gpx object
    var gpx = Gpx();
    gpx.creator = "dart-gpx library";
    gpx.wpts = [
      Wpt(
          lat: this.lat,
          lon: this.lon,
          ele: this.elevation,
          name: this.name,
          desc: this.desc),
    ];

    // generate xml string
    var gpxString = GpxWriter().asString(gpx, pretty: true);

    return file.writeAsString(gpxString);
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/${this.name}.gpx");
  }
}
