import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
    var compressedFile = await testCompressAndGetFile(_image);
    try {
      List<int> imageBytes = await compressedFile.readAsBytes();
      print('length2 -- ${imageBytes.length}');
      return base64Encode(imageBytes);
    } catch (e) {
      print('error -- ${e.toString()}');
    }
    return null;
  }

  static Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  //compress file
  // 2. compress file and get file.
  static Future<File> testCompressAndGetFile(File file) async {
    var tempPath = await _localPath;
    print(tempPath);
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      "$tempPath.jpg",
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
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
      showToast("Wrong number format $number");
      throw FormatException("Wrong number format $number");
    }
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
