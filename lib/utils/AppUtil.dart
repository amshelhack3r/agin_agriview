import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class AppUtil{

  static Future<String> getFileNameWithExtension(File file)async{

    if(await file.exists()){
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.basename(file.path);
    }else{
      return null;
    }
  }

  static Future<String> getFileExtension(File file)async{

    if(await file.exists()){
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.extension(file.path);
    }else{
      return null;
    }
  }


  static Future<String> getImageAsBase64(File _image) async{
    print('length -- ${_image.length()}');
    try {
      List<int> imageBytes = await _image.readAsBytes();
      print('length2 -- ${imageBytes.length}');
      return base64Encode(imageBytes);
    }catch(e){
      print('error -- ${e.toString()}');
    }

  }

}