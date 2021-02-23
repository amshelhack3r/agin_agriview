import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:intl/intl.dart';

class AppUtil {
  static Future<String> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  static Future<String> getFileExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.extension(file.path);
    } else {
      return null;
    }
  }

  static Future<String> getImageAsBase64(File _image) async {
    print('length -- ${_image.length()}');
    try {
      List<int> imageBytes = await _image.readAsBytes();
      print('length2 -- ${imageBytes.length}');
      return base64Encode(imageBytes);
    } catch (e) {
      print('error -- ${e.toString()}');
    }
    return null;
  }

  static formatMobileNumber(String number) {
    var mobile = '254';
    //check if it begins with 254
    if (number.startsWith('254')) {
      return number;
    } else if (number.startsWith('+254')) {
      return number.substring(1);
    } else if (number.startsWith('0')) {
      mobile += number.substring(1);
      return mobile;
    } else {
      Sentry.captureException("Wrong number format $number");
      throw FormatException("Wrong number format $number");
    }
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
