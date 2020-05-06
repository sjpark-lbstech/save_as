import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:save_as/data/img_content.dart';

class MainChannel{
  static final String mainChannelName = "proj.net.lbstech.main_channel";
  static final String keyEventChannelName = "proj.net.lbstech.key_event";

  final MethodChannel _channel = MethodChannel(mainChannelName);
  final EventChannel _keyEvent = EventChannel(keyEventChannelName);
  StreamSubscription _subscription;

  MainChannel._internal();
  static final MainChannel _instance = MainChannel._internal();

  factory MainChannel() => _instance;


  /// 기기의 종류와 SDK version 을 반환한다.
  ///
  /// 'osType'과 'version' 2개의 Key-Value 를 가진 [Map]을 반환한다.
  ///
  /// ```dart
  /// Map result = await getInformation();
  /// String osType = result['osType']
  /// // osType은 'android' 또는 'iOS' 를 가진다
  /// int sdkVersion = result['version']
  /// ```
  /// @end
  ///
  Future<Map<String, dynamic>> getInformation() async {
    Map arg = await _channel.invokeMethod<Map>("device");
    return <String, dynamic>{
      'osType' : arg['osType'],
      'version' : arg['version']
    };
  }


  /// 기기의 종류와 SDK version 을 반환한다.
  ///
  /// 'latitude'과 'longitude' 2개의 Key-Value 를 가진 [Map]을 반환한다.
  ///
  /// ```dart
  /// Map result = await getInformation();
  /// double latitude = result['latitude']
  /// double longitude = result['longitude']
  /// ```
  /// @end
  ///
  Future<Map<String, double>> getLocation() async {
    Map arg = await _channel.invokeMethod('location');
    return <String, double>{
      'latitude' : arg['latitude'],
      'longitude' : arg['longitude']
    };
  }


  /// 인터넷 연결을 확인하고 결과값을 반환한다.
  /// 인터넷 연결이 되어 있는 경우 true, 아닌 경우 false 가 반환된다
  /// 해당 기능을 사용하기 위해서는 다음의 권한을 등록하여야 한다.
  ///
  /// @ android - manifest
  /// ```
  /// <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  /// <uses-permission android:name="android.permission.INTERNET"/>
  /// ```
  /// @ end
  ///
  Future<bool> getConnectionState() async {
    return await _channel.invokeMethod('connection');
  }


  /// 임시 저장 디렉토리를 반환한다.
  ///
  /// android 에서는 'getCacheDir'을 이용하고
  /// iOS 에서는 'NSCachesDirectory' 를 사용한다
  Future<Directory> getTempDirectory() async {
    String tmpDirPath = await _channel.invokeMethod('dir#tmp');
    return tmpDirPath != null ? Directory(tmpDirPath) : null;
  }


  /// 임시 저장 디렉토리를 반환한다.
  /// 해당 기능을 사용하기 위해서는 android에
  /// <WRITE_EXTERNAL_STORAGE> 권한을 필요로 한다.
  ///
  /// android 에서는 'Environment.DIRECTORY_DCIM'을 이용하고
  /// iOS 에서는 'NSCachesDirectory' 를 사용한다
  Future<Directory> getPublicDirectory() async {
    String publicDirPath = await _channel.invokeMethod('dir#public');
    return publicDirPath != null ? Directory(publicDirPath) : null;
  }


  /// 외부 저장소에 있는 모든 이미지를 가져와서 [ImageContent]로 변환한다.
  /// </br>
  /// [ImageContent]에는 원본의 절대 경로에 접근하는 [File]과
  /// 썸네일의 절대 경로에 접근하는 [File]이 있다.
  Future<List<ImageContent>> getImageContents() async{
    List<ImageContent> contents = [];
    List args = await _channel.invokeMethod<List>('imageContent');
    for (dynamic arg in args){
      Map contentData = arg;
      contents.add(ImageContent.fromMap(contentData));
    }
    return contents;
  }


  /// Notification 을 띄운다.
  /// </br>
  /// 전달된 [title]과 [msg] 대로 노티피케이션을 활성화한다.
  Future<void> showSelfNotification(String title, String msg) async {
    Map<String, String> arg = {
      "title" : title,
      "msg" : msg,
    };
    return _channel.invokeMethod<void>('show#noti', arg);
  }


  /// key 이벤트 채널을 받기 시작한다.
  /// VOLUME_UP 버튼은 [1], VOLUME_DOWN 버튼은 [2]를 누른다.
  void keyEventOn(void Function(dynamic value) onKeyDown){
    if (_subscription != null) {
      print('이미 스트림이 활성화 상태 입니다.');
      return;
    }
    _subscription = _keyEvent.receiveBroadcastStream().listen(onKeyDown);
  }


  /// key 이벤트 채널을 닫는다.
  void keyEventOff(){
    if (_subscription == null) {
      print('스트림은 비활성화 상태입니다.');
      return;
    }
    _subscription.cancel();
    _subscription = null;
  }
}