import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:meta/meta.dart';
import './ch_main.dart';

class OpenCV{
  static const String CHANNEL_OPENCV = "proj.net.lbstech.open_cv_channel";

  static const String METHOD_CANNY = 'getCanny';
  static const String METHOD_ROTATE_CLOCKWISE = 'rotateClockWise';
  static const String METHOD_ROTATE_COUNTER_CLOCKWISE = 'rotateCounterClockWise';

  final MethodChannel _channel = MethodChannel(CHANNEL_OPENCV);


  /// 썸네일을 이용한 외곽선 추출 추천.
  Future<bool> getCanny({@required String srcPath,
    @required String edgePath}) async{

    if(srcPath == null || edgePath == null) return false;
    bool result = await _channel.invokeMethod(METHOD_CANNY, <String, String>{
      'src' : srcPath,
      'edge' : edgePath,
    });

    return result;
  }

//
//  Future<bool> rotateClockWise({@required String srcPath,
//    @required String edgePath}) async{
//
//    if(srcPath == null || edgePath == null) return false;
//    bool result = await _channel.invokeMethod(METHOD_ROTATE_CLOCKWISE,
//        <String, String>{
//          'src' : srcPath,
//          'edge' : edgePath,
//        });
//
//    return result;
//  }
//
//  Future<bool> rotateCounterClockWise({@required String srcPath,
//    @required String edgePath}) async{
//
//    if(srcPath == null || edgePath == null) return false;
//    bool result = await _channel.invokeMethod(METHOD_ROTATE_COUNTER_CLOCKWISE,
//        <String, String>{
//          'src' : srcPath,
//          'edge' : edgePath,
//        });
//
//    return result;
//  }

  Future<File> downloadFromStorage(String downloadUrl) async{
    String filePath = await getTempPath();
    File srcFile = File(filePath);

    http.Response response = await http.get(downloadUrl);
    var bytes = response.bodyBytes;
    await srcFile.writeAsBytes(bytes);

    return srcFile;
  }

  Future<String> getTempPath() async{
    Directory tmpDir = await MainChannel().getTempDirectory();
    String tmpPath = '${tmpDir.path}/opencv';

    await Directory(tmpPath).create(recursive: true);

    String tmpName = DateTime.now().toIso8601String();
    String filePath = '${tmpPath}/$tmpName.png';

    return filePath;
  }

}