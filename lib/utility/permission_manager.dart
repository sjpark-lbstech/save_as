import 'package:flutter/material.dart';
import 'package:save_as/channel/ch_permission.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionManager{

  static final PermissionManager _instance = PermissionManager._internal();
  factory PermissionManager() => _instance;

  PermissionManager._internal();
  PermissionChannel _channel = PermissionChannel();

  SharedPreferences _preferences;

  /// 필요한 권한들이 모두 Granted 일때만 true.
  /// 하나 이상 거부 되어있는 경우 false 반환
  ///
  /// 이후 [SharedPreferences] 에 상태 저장
  Future<bool> check() async{
    if (_preferences == null){
      _preferences = await SharedPreferences.getInstance();
    }
    bool policyState = false;
    if (_preferences.containsKey('policy') && _preferences.getBool('policy')){
      policyState = true;
    }

    bool permissionState = await _channel.checkState();
    return permissionState && policyState;
  }

  /// 권한 요청
  /// 동적 권한 요청을 위한 다이얼로그 표시.
  ///
  /// 모든 권한 수락시 true 반환
  Future request() async{
    return await _channel.requestPermission();
  }

  /// 정책 동의시 [SharedPreferences] 에 상태 저장
  void accept() async{
    if (_preferences == null){
      _preferences = await SharedPreferences.getInstance();
    }
    _preferences.setBool('policy', true);
  }

}