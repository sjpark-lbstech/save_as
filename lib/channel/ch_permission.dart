import 'dart:async';
import 'package:flutter/services.dart';

class PermissionChannel {
  static final String channelName = "proj.net.lbstech.permission_channel";

  static final PermissionChannel _instance = PermissionChannel._internal();
  static final MethodChannel _channel = MethodChannel(channelName);

  PermissionChannel._internal();

  factory PermissionChannel()=> _instance;

  /// 필요한 권한들이 모두 Granted 일때만 true.
  /// 하나 이상 거부 되어있는 경우 false 반환
  Future<bool> checkState() async {
    return _channel.invokeMethod<bool>("check");
  }

  /// 권한 요청
  /// 동적 권한 요청을 위한 다이얼로그 표시.
  ///
  /// 모든 권한 수락시 true 반환
  Future<bool> requestPermission() async {
    return _channel.invokeMethod<bool>("request");
  }

}